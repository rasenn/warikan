require 'rails_helper'

RSpec.describe WarikanUtil, :type => :model do
  describe "#create_list" do
    it "can be create" do
      expect(WarikanUtil.create_list.integer?).to eq true
    end

    it "create different id every time" do
      one = WarikanUtil.create_list
      two = WarikanUtil.create_list
      expect(one != two).to eq true
    end
    
  end

  describe "#add_member" do
    context "when list exist" do
      let!(:list_id){WarikanUtil.create_list} 
      it "can add member" do
        expect(WarikanUtil.add_member(list_id, "sample user").integer?).to eq true
      end
    end

    context "when list NOT exist" do
      it "can NOT add member" do
        expect(WarikanUtil.add_member(-1, "sample user")).to eq false
      end
    end
  end

  describe "#add_kingaku" do
    context "when list and member exist" do 
      let!(:list_id) {WarikanUtil.create_list}
      let!(:member_id) {WarikanUtil.add_member(list_id)}
      it "can add kingaku" do
        expect(WarikanUtil.add_kingaku(list_id, member_id, 123, "warikan memo").integer?).to eq true
      end
    end
    
    context "when list NOT exist" do
      it "can NOT add kingaku" do
        expect(WarikanUtil.add_kingaku(-1, -1, 123, "warikan memo")).to eq false
      end
    end
    
    context "when member NOT exist" do
      let!(:list_id) {WarikanUtil.create_list}
      it "can NOT add kingaku" do
        expect(WarikanUtil.add_kingaku(list_id, -1, 123, "warikan memo")).to eq false
      end
    end
  end
end
