class WarikanUtil

  def self.create_list
    list = List.new
    list.url_hash = SecureRandom.urlsafe_base64(10)
    list.created_at = Time.now
    return list.save ? list.id : self.create_list
  end

  def self.add_member(list_id,member_name)
    member = Member.new
    member.lists_id = list_id
    member.name = member_name
    member.save ? member.id : false
  end

  # TODO class check
  def self.add_kingaku(list_id,member_id,kingaku,memo)
    kingaku = Kingaku.new
    kingaku.lists_id = list_id
    kingaku.members_id = member_id
    kingaku.kingaku = kingaku
    kingaku.memo = memo
    kingaku.save ? kingaku.id : false
  end

  def self.already_added?(list_id,kingaku)
    result = Kingaku.find_by("list_id=? and kingaku=? and created_at>=?", [list_id, kingaku, (Time.now - (60*60))])
    return result && result.count > 0 
  end

  def self.delete_member(list_id, member_id)
    member = Member.find_by("id=?", member_id)
    member.delete if member
  end

  def self.delete_kingaku(kingaku_id)
    kingaku = Kingaku.find_by("id=?",kingaku_id)
    kingaku.delete if kingaku
  end

  def self.calc_shiharaigaku(list_id)
    lists = List.find_by("id=?", list_id).includes([:members, :kingakus])
    members = lists.members
    kingakus = lists.kingakus

    # init
    member_kingakus = Hash.new
    id2member = Hash.new
    members.each do |m|
      member_kingakus[m.id] = 0
      id2member[m.id] = m.name
    end
    sum = 0
    m_count = 0

    # calc
    kingakus.each do |k|
      member_kingakus[k.member_id] += k.kingaku
      sum += kingaku
      m_count += 1
    end

    # create return
    result = Array.new
    id2member.each do |m_id, m_name|
      result.push [m_id, m_name, (m_count/3 - member_kingakus[m_id])]
    end

    return result
  end

  def self.delete_list
    # TODO
  end
  
end
