require 'spec_helper'

include Validity

describe Record do
  before(:all) do
    Validity.configure(TestUnit)
  end

  before(:each) do
    user = User.new({email: 'test@email.com'})
    user.save!
    @user = Record.validates(user)
    post = Post.new({body: 'body'})
    post.user = user
    post.save!
    @post = Record.validates(post)
  end

  after(:each) do
    @user.record.destroy!
    @post.record.destroy!
  end

  describe '#belongs_to' do
    it 'tests the belongs_to association' do
      @post.belongs_to :user, @user.record
    end
  end

  describe '#delegates' do
    it 'tests delegation' do
      @post.delegates :email, @user.record
    end
  end

  describe '#field_presence' do
    it 'tests field presence' do
      @user.field_presence :email
    end
  end

  describe '#field_uniqueness' do
    it 'tests field uniqueness' do
      @user.field_uniqueness :email
    end
  end

  describe '#has_many' do
    it 'tests the has_many association' do
      @user.has_many :posts, [@post.record]
    end
  end
end

