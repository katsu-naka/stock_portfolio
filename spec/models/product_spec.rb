require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'ポートフォリオ投稿' do
    before do
      @product = FactoryBot.build(:product)
    end

    context 'ポートフォリオ投稿が成功する' do
      it '全ての項目が存在すれば登録できる' do
        expect(@product).to be_valid
      end
    end
    context 'ポートフォリオ投稿が失敗する' do
      it 'titleが空だと投稿できない' do
        @product.title = ""
        @product.valid?
        expect(@product.errors.full_messages).to include("Title can't be blank")
      end
    end
  end
end
