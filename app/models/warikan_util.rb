class WarikanUtil

  def self.create_list(name=nil)
    list = List.new
    list.url_hash = SecureRandom.urlsafe_base64(10)
    list.name = name
    list.created_at = Time.now
    return list.save ? list.id : self.create_list
  end

  def self.add_member(list_id,member_name)
    return false unless List.find_by("id=?",list_id)
    member = Member.new
    member.list_id = list_id
    member.name = member_name
    member.save ? member.id : false
  end

  # TODO class check
  def self.add_kingaku(list_id,member_id,ikingaku,memo,members)
    return false unless List.find_by("id=?",list_id) && Member.find_by("id=?",member_id)
    kingaku = Kingaku.new
    kingaku.list_id = list_id
    kingaku.member_id = member_id
    kingaku.kingaku = ikingaku
    kingaku.memo = memo
    kingaku.save ? kingaku.id : false

    members.each do |m|
      w = Who.new
      w.kingaku_id = kingaku.id
      w.member_id = m[0]
      w.save
    end

  end

  def self.already_added?(list_id,kingaku)
    result = Kingaku.find_by("list_id=? and kingaku=? and created_at>=?", list_id, kingaku, (Time.now - (60*60)))
    return result ? true : false
  end

  def self.delete_member(list_id, member_id)
    member = Member.find_by("id=?", member_id)
    member.delete if member
  end

  def self.delete_kingaku(kingaku_id)
    kingaku = Kingaku.includes(:whos).find_by("id=?",kingaku_id)
    kingaku.whos.each do |w|
      w.delete
    end
    
    kingaku.delete if kingaku
  end

  def self.calc_shiharaigaku(list_id)
    lists = List.includes([:members, { kingakus: [:whos] }, :paids]).find_by("id=?", list_id)
    members = lists.members
    kingakus = lists.kingakus

    # init
    m_count = 0
    member_kingakus = Hash.new
    id2member = Hash.new
    members.each do |m|
      member_kingakus[m.id] = 0
      id2member[m.id] = m.name
      m_count += 1
    end
    sum = 0

    
    # calc
    kobetsu = false
    kingakus.each do |k|
      # 支払メンバがない場合、後方互換のために残す
      if k.whos.size == 0
        kobetsu = true
        member_kingakus[k.member_id] += k.kingaku
        sum += k.kingaku

      # 支払メンバがある場合
      else
        # 立て替えたメンバに受取金額を追加
        member_kingakus[k.member_id] += k.kingaku

	# 各メンバで割り勘した金額を追記
	k.whos.each do |w|
          member_kingakus[w.member_id] -= (k.kingaku / k.whos.size ).to_i
	end
      end
    end

    # 個別支払の精算計算
    lists.paids.each do |pay|
      member_kingakus[pay.pay_member_id] += pay.kingaku
      member_kingakus[pay.recieve_member_id] -= pay.kingaku
    end

    # create return
    result = Array.new
    id2member.each do |m_id, m_name|
      if kobetsu
        result.push [m_id, m_name, (sum/m_count - member_kingakus[m_id])]
      else
        result.push [m_id, m_name, ( - member_kingakus[m_id])]
      end
    end

    return result
  end

  def self.delete_list
    # TODO
  end

  def self.paid(list_id,pay_member_id,recieve_member_id,cost,memo)
    return false unless List.find_by("id=?",list_id) && Member.find_by("id=?",pay_member_id) &&
                        Member.find_by("id=?",recieve_member_id) 

    if pay_member_id == recieve_member_id
      return false
    end

    paid = Paid.new
    paid.list = List.find_by("id=?",list_id)
    paid.kingaku = cost.to_i
    paid.pay_member_id = pay_member_id.to_i
    paid.recieve_member_id = recieve_member_id.to_i
    paid.memo = memo
    paid.save ? paid.id : false

  end

  def self.delete_paid(paid_id)
    paid = Paid.find_by("id=?",paid_id)
    paid.delete if paid
  end
end
