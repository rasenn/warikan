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
  def self.add_kingaku(list_id,member_id,ikingaku,memo)
    return false unless List.find_by("id=?",list_id) && Member.find_by("id=?",member_id)
    kingaku = Kingaku.new
    kingaku.list_id = list_id
    kingaku.member_id = member_id
    kingaku.kingaku = ikingaku
    kingaku.memo = memo
    kingaku.save ? kingaku.id : false
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
    kingaku = Kingaku.find_by("id=?",kingaku_id)
    kingaku.delete if kingaku
  end

  def self.calc_shiharaigaku(list_id)
    lists = List.includes([:members, :kingakus]).find_by("id=?", list_id)
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
    kingakus.each do |k|
      member_kingakus[k.member_id] += k.kingaku
      sum += k.kingaku
    end

    # create return
    result = Array.new
    id2member.each do |m_id, m_name|
      result.push [m_id, m_name, (sum/m_count - member_kingakus[m_id])]
    end

    return result
  end

  def self.delete_list
    # TODO
  end
  
end
