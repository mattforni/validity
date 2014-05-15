require 'spec_helper'

describe Validity do

  before(:each) do
    Validity.reset!
  end

  describe '::configure' do
    context 'with unsupported module' do
      it 'raises an Unsupported error' do
        expect { Validity.configure('Unsupported') }.to raise_error(Validity::Unsupported) 
      end
    end

    context 'with supported module' do
      Validity.supported.each do |supported|
        context supported.to_s do
          it 'return true' do
            expect(Validity.configure(supported)).to be_true
          end
        end
      end
    end
  end

  describe '::configured?' do
    context 'when not configured' do
      it 'returns false' do
        expect(Validity.configured?).to be_false
      end
    end

    context 'when configured' do
      Validity.supported.each do |supported|
        context "with #{supported}" do
          it 'returns true' do
            Validity.configure(Validity::TestUnit)
            expect(Validity.configured?).to be_true
          end
        end
      end
    end
  end

  describe '::reset!' do
    context 'when not not configured' do
      it 'does nothing' do
        expect(Validity.configured?).to be_false
        Validity.reset!
        expect(Validity.configured?).to be_false
      end
    end

    context 'when configured' do
      it 'resets Validity' do
        Validity.configure(Validity.supported.first)

        expect(Validity.configured?).to be_true
        Validity.reset!
        expect(Validity.configured?).to be_false
      end
    end
  end
end

