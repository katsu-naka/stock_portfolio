require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'コメント送信' do
    before do
      @comment = FactoryBot.build(:comment)
    end

    context 'コメント送信が成功する' do
      it "全ての項目が正しく入力されていれば送信できる" do
        expect(@comment).to be_valid
      end
    end
    context 'コメント送信が失敗する' do
      it "commentが空だと送信できない" do
        @comment.comment = ""
        @comment.valid?
        expect(@comment.errors.full_messages).to include("Comment can't be blank")
      end
    end
  end
end
