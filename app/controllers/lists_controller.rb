# coding: utf-8
class ListsController < ApplicationController
  def new
  end

  def init
    list_id = WarikanUtil.create_list
    @list = List.find_by("id=?",list_id)
  end

  def list
    redirect_to "root" unless params["url_hash"]
    @list = List.includes([{paids: [:pay_member, :recieve_member], kingakus: [:member]}, :members]).find_by("url_hash=?",params["url_hash"])

    # リスト新規作成時
    if params["members"] && params["name"]
      @list.name = params["name"]
      @list.save
      params["members"].each do |m|
        WarikanUtil.add_member(@list.id,m)
      end
      params["url_hash"] = @list.url_hash
    end
    
    # 立替対象メンバの名前変換用
    @id2name = Hash.new
    @list.members.each do |m|
      @id2name[m.id] = m.name
    end

    @kingakus = @list.kingakus
    @shiharaigaku = WarikanUtil.calc_shiharaigaku(@list.id)
  end
  
  def add_kingaku
    redirect_to "root" unless params["url_hash"]
    @list = List.includes("members").find_by("url_hash=?",params["url_hash"])
    @members = @list.members
  end

  # params = {before_confirm, kingaku, url_hash, memo, member_id}
  def confirm_kingaku
    redirect_to "root" unless params["url_hash"]
    p params
    if params["kingaku"] && params["member_id"]

      list = List.find_by("url_hash=?", params["url_hash"])
#      if params["before_confirm"] == "true" && WarikanUtil.already_added?(list.id, params["kingaku"])
#        @member_id = params["member_id"]
#        @kingaku = params["kingaku"]
#        @url_hash = params["url_hash"]
#        @memo = params["memo"]
#      else
      WarikanUtil.add_kingaku(list.id, params["member_id"].to_i, params["kingaku"].to_i, params["memo"],params[:member])
      p params[:member]
      redirect_to :action => "list", :url_hash => list.url_hash

    else
      redirect_to :action => "add_kingaku", :url_hash => params[:url_hash], :warning => "入力してください。"      

    end
#      end   
  end

  def delete_kingaku
    redirect_to "root" unless params["url_hash"]
    if params["kingaku_id"]
      WarikanUtil.delete_kingaku(params["kingaku_id"].to_i)
    end
    redirect_to :action => "list", :url_hash => params["url_hash"]    
  end
  
  def edit_member
    redirect_to "root" unless params["url_hash"]
    if params[:act] == "delete"
      member = Member.includes("kingakus").find_by("id=?",params["member_id"])
      if member
        unless member.kingakus.size > 0
          list = List.find_by("url_hash=?",params["url_hash"])
          WarikanUtil.delete_member(list.id, params["member_id"])
        else
          @flash = "支払いがあるため、削除できません。"
        end
      end
    elsif params[:act] == "add" && params["name"]
      list = List.find_by("url_hash=?",params["url_hash"])
      WarikanUtil.add_member(list.id,params["name"])
    end

    list = List.includes("members").find_by("url_hash=?",params["url_hash"])
    @members = list.members
    @url_hash = params["url_hash"]
  end

  def paid
    redirect_to "root" unless params["url_hash"]
    @list = List.find_by("url_hash=?",params["url_hash"])
    @list = List.includes(:members).find_by("url_hash=?",params["url_hash"])
    @members = @list.members
  end

  def add_paid
    redirect_to "root" unless params["url_hash"]
    @list = List.find_by("url_hash=?",params["url_hash"])
    result = false
    if params["member_id_pay"] && params["member_id_recieve"] && 
       params["kingaku"] && params["memo"]
       result = WarikanUtil.paid(@list.id,params["member_id_pay"], params["member_id_recieve"], 
              	        params["kingaku"], params["memo"])
    end
    # 結果がfalse = 支払メンバと受取メンバが同じ場合
    if params["kingaku"].to_i == 0 
      redirect_to ({:action => "paid", :url_hash => params["url_hash"] }),
                   warning: "金額が入力されていません。"
    elsif result
      redirect_to :action => "list", :url_hash => params["url_hash"]    
    else
      redirect_to ({:action => "paid", :url_hash => params["url_hash"] }), 
      		   warning: "支払いメンバと受取りメンバが同じです。"
    end
  end

  def delete_paid
    redirect_to "root" unless params["url_hash"]
    if params["paid_id"]
      WarikanUtil.delete_paid(params["paid_id"].to_i)
    end
    redirect_to :action => "list", :url_hash => params["url_hash"]
  end


end
