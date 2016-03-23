require 'rails_helper'

RSpec.describe ListsController, :type => :controller do

  describe "GET list" do
    it "returns http success" do
      get :list
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET initialize" do
    it "returns http success" do
      get :initialize
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET add_kingaku" do
    it "returns http success" do
      get :add_kingaku
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET edit_member" do
    it "returns http success" do
      get :edit_member
      expect(response).to have_http_status(:success)
    end
  end

end
