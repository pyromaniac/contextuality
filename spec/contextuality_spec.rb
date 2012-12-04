require 'spec_helper'

describe Contextuality do
  let(:klass) do
    Class.new do
      include Contextuality

      def hello
        contextuality.hello
      end

      def goodbye
        contextuality.goodbye
      end
    end
  end
  subject { klass.new }

  context 'linear' do
    specify { subject.hello.should be_nil }

    specify do
      contextualize do
        subject.hello.should be_nil
      end
    end

    specify do
      contextualize do
        Contextuality.hello.should be_nil
      end
    end

    specify do
      contextualize(:hello => 'world') do
        subject.hello.should == 'world'
      end
    end

    specify do
      contextualize(:hello => 'world') do
        Contextuality.hello.should == 'world'
      end
    end

    specify do
      contextualize(:hello => 'world') do
        contextualize(:hello => 'hell') do
          subject.hello.should == 'hell'
        end
      end
    end

    specify do
      contextualize(:hello => 'world') do
        contextualize(:goodbye => 'hell') do
          subject.hello.should == 'world'
        end
      end
    end
  end

  context 'threaded' do
    specify do
      contextualize(:hello => 'world') do
        Thread.new do
          Thread.current[:output] = subject.hello
        end.join[:output].should == 'world'
      end
    end

    specify do
      contextualize(:hello => 'world') do
        Thread.new do
          contextualize(:hello => 'hell') do
            Thread.current[:output] = subject.hello
          end
        end.join[:output].should == 'hell'
      end
    end

    specify do
      contextualize(:goodbye => 'hell') do
        Thread.new do
          contextualize(:hello => 'world') do
            Thread.current[:output] = [subject.hello, subject.goodbye]
          end
        end.join[:output].should == ['world', 'hell']
      end
    end
  end

  context 'defaults' do
    before { Contextuality.defaults[:foo] = 'Bar' }

    specify { Contextuality.foo.should == 'Bar' }

    specify do
      contextualize do
        Contextuality.foo.should == 'Bar'
      end
    end

    specify do
      contextualize(foo: 'Hello') do
        Contextuality.foo.should == 'Hello'
      end
    end
  end
end
