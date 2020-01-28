# frozen_string_literal: true

require 'spec_helper'
describe CommaSplice do
  describe "tricky lines:" do
    let(:header) do
      'playid,playtype,genre,timestamp,artist,title,albumtitle,label,prepost,programtype,iswebcast,isrequest'
    end

    subject do
      CommaSplice.debug = true
      line = CommaSplice::LineCorrector.new(header, values, 4, -5)
      # line.print_all_options

      line
    end

    describe 'comma separated list ended with punctuation' do
      let(:values) do
        "17252289,,,10-12-2018 @ 23:03:00,Robbie Fulks & Linda Gail Lewis,That's Why They Call It Temptation,Wild,Wild, Wild!,Bloodshot,post,live,y,"
      end

      let(:corrected_values) do
        %(17252289,,,10-12-2018 @ 23:03:00,Robbie Fulks & Linda Gail Lewis,That's Why They Call It Temptation,"Wild,Wild, Wild!",Bloodshot,post,live,y,\n)
      end

      it 'should prompt with two options' do
        expect(subject.option_count).to eq(4)
      end

      it 'should prompt for the correction' do
        expect($stdin).to receive(:gets).and_return('2')
        expect(subject.corrected).to eq(corrected_values)
      end
    end

    describe 'accidental trailing comma in quoted section' do
      let(:values) do
        '16561154,,,05-13-2017 @ 13:57:00,Neil Finn,Turn and Run,One All,Nettwerk America,,post,live,y,'
      end

      let(:corrected_values) do
        %(16561154,,,05-13-2017 @ 13:57:00,Neil Finn,Turn and Run,One All,"Nettwerk America,",post,live,y,\n)
      end

      it 'should autocorrect' do
        expect(subject.corrected).to eq(corrected_values)
      end
    end

    describe 'huge comma separated list within an option' do
      let(:values) do
        '14997991,,,07-17-2015 @ 18:34:00,Deftones,U,U,D,D,L,R,L,R,Select,Start,Saturday Night Wrist,Maverick,post,live,y,'
      end

      let(:corrected_values) do
        %(14997991,,,07-17-2015 @ 18:34:00,Deftones,"U,U,D,D,L,R,L,R,Select,Start",Saturday Night Wrist,Maverick,post,live,y,\n)
      end

      it 'should prompt with the correct number options' do
        expect(subject.option_count).to eq(4)
      end

      it 'should prompt for options' do
        expect($stdin).to receive(:gets).and_return('3')
        expect(subject.corrected).to eq(corrected_values)
      end
    end

    describe 'accidental trailing comma followed by blank field' do
      let(:values) do
        '11652541,,,03-15-2014 @ 13:52:00,Electric Prunes,Get Me to The World on Time,45 rpm,,Hearbeat,post,live,y,'
      end

      let(:corrected_values) do
        %(11652541,,,03-15-2014 @ 13:52:00,Electric Prunes,Get Me to The World on Time,"45 rpm,",Hearbeat,post,live,y,\n)
      end

      it 'should prompt with the correct number options' do
        expect(subject.option_count).to eq(2)
      end

      it 'should be corrected with right option' do
        expect($stdin).to receive(:gets).and_return('2')
        expect(subject.corrected).to eq(corrected_values)
      end
    end

    describe 'comma instead of apostrophe' do
      let(:values) do
        '16659097,,,08-06-2017 @ 09:49:00,Michael Bloomfield,City Girl,If You Love These Blues Play,em as You Please,Guitar Player Records,post,live,y,'
      end

      let(:corrected_values) do
        %(16659097,,,08-06-2017 @ 09:49:00,Michael Bloomfield,City Girl,"If You Love These Blues Play,em as You Please",Guitar Player Records,post,live,y,\n)
      end

      it 'should prompt with the correct number options' do
        subject.print_all_options
        expect(subject.option_count).to eq(4)
      end

      it 'should be corrected with right option' do
        expect($stdin).to receive(:gets).and_return('2')
        expect(subject.corrected).to eq(corrected_values)
      end
    end

    describe 'trailing comma' do
      let(:values) do
        '16659089,,,09-15-2012 @ 14:45:00,Vana Mazi,Boom Shaka Laka,,Live on KOOP,n/a,post,live,y,'
      end

      let(:corrected_values) do
        %(16659089,,,09-15-2012 @ 14:45:00,Vana Mazi,"Boom Shaka Laka,",Live on KOOP,n/a,post,live,y,\n)
      end

      it 'should prompt with the correct number options' do
        expect(subject.option_count).to eq(2)
      end

      it 'should be corrected with right option' do
        expect($stdin).to receive(:gets).and_return('2')
        expect(subject.corrected).to eq(corrected_values)
      end
    end

    describe 'incorrectly quoted comma' do
      let(:values) do
        %q(16659092,,,10-29-2011 @ 14:11:00,"Murder," He Says,Gene Krupa and His Orchestra; Anita O' Day,Young Anita,Proper Box,post,live,y,)
      end

      let(:corrected_values) do
        %(16659092,,,10-29-2011 @ 14:11:00,"""Murder,"" He Says",Gene Krupa and His Orchestra; Anita O' Day,Young Anita,Proper Box,post,live,y,\n)
      end

      it 'should be corrected with right option' do
        expect(subject.corrected).to eq(corrected_values)
      end
    end

    describe 'volumes' do
      let(:values) do
        %q(17096459,,Country,06-14-2018 @ 12:56:00,United Guitar Players,On the Road Again,Country Music Classics on Instrumental Accoustic Guitars,Vol. 1,self-released,post,live,y,)
      end

      let(:corrected_values) do
        %(17096459,,Country,06-14-2018 @ 12:56:00,United Guitar Players,On the Road Again,"Country Music Classics on Instrumental Accoustic Guitars,Vol. 1",self-released,post,live,y,\n)
      end

      it 'should be corrected with right option' do
        expect($stdin).to receive(:gets).and_return('2')
        expect(subject.corrected).to eq(corrected_values)
      end
    end

    describe 'volume 3' do
      let(:values) do
        %q(16870572,Compact Disc,Country,01-04-2018 @ 09:01:00,Spade Cooley,Oklahoma Stomp,Swing West,Vol. 3,Razor and Tie,,live,y,)
      end

      let(:corrected_values) do
        %(16870572,Compact Disc,Country,01-04-2018 @ 09:01:00,Spade Cooley,Oklahoma Stomp,"Swing West,Vol. 3",Razor and Tie,,live,y,\n)
      end

      it 'should be corrected with right option' do
        expect($stdin).to receive(:gets).and_return('2')
        expect(subject.corrected).to eq(corrected_values)
      end

    end

    describe 'value with a comma in it' do
      let(:values) do
        %q(16998473,MP3 or Other Digital Audio File,Pop,04-07-2018 @ 17:03:00,Locate S,1,Owe It 2 the Girls,Healing Contest,Sybaritic Peer,,live,y,)
      end
      let(:corrected_values) do
        %(16998473,MP3 or Other Digital Audio File,Pop,04-07-2018 @ 17:03:00,"Locate S,1",Owe It 2 the Girls,Healing Contest,Sybaritic Peer,,live,y,\n)
      end

      it 'should be corrected with right option' do
        expect($stdin).to receive(:gets).and_return('4')
        expect(subject.corrected).to eq(corrected_values)
      end
    end
  end
end
