require 'spec_helper'

describe Contextuality::Context do
  subject { described_class.new }

  describe '#initialize' do
    it { should be_empty }
  end

  describe '#push' do
    before { subject.push(:hello => 'world') }

    it { should_not be_empty }
  end

  describe '#pop' do
    context do
      before do
        subject.push(:hello => 'world')
        subject.pop
      end

      it { should be_empty }
      specify { expect { subject.pop }.not_to raise_error }
    end

    context do
      before do
        subject.push(:hello => 'world')
        subject.push(:hello => 'world')
        subject.pop
      end

      it { should_not be_empty }
    end

    context do
      before do
        subject.push(:hello => 'world')
        subject.push(:hello => 'world')
        subject.pop
        subject.pop
      end

      it { should be_empty }
    end
  end

  describe '#[] and key?' do
    context 'indifferent access' do
      before { subject.push(:hello => 'world') }

      specify { subject[:hello].should == 'world' }
      specify { subject['hello'].should == 'world' }
      specify { subject[:goodbye].should be_nil }
      specify { subject.key?(:hello).should be_true }
      specify { subject.key?('hello').should be_true }
      specify { subject.key?(:goodbye).should be_false }
    end

    context 'merging' do
      before do
        subject.push(:hello => 'world')
        subject.push(:goodbye => 'hell')
      end

      specify { subject[:hello].should == 'world' }
      specify { subject[:goodbye].should == 'hell' }
      specify { subject.key?(:hello).should be_true }
      specify { subject.key?(:goodbye).should be_true }
    end

    context 'overlapping' do
      before do
        subject.push(:hello => 'world')
        subject.push(:hello => 'hell')
      end

      specify { subject[:hello].should == 'hell' }
      specify { subject.key?(:hello).should be_true }
    end

    context 'overlapping cancel' do
      before do
        subject.push(:hello => 'world')
        subject.push(:hello => 'hell')
        subject.pop
      end

      specify { subject[:hello].should == 'world' }
      specify { subject.key?(:hello).should be_true }
    end
  end

  describe '#method_missing' do
    before { subject.push(:hello => 'world') }
    its(:hello) { should == 'world' }
    its(:goodbye) { should be_nil }
  end
end
