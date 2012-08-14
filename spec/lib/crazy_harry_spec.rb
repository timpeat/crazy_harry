require 'spec_helper'

describe CrazyHarry do
  TAGS_TO_REMOVE = {
      paragraph:  '<p></p>',
      ul:         '<ul></ul>',
      div:        '<div></div>'
    }

  let(:harry) { CrazyHarry }

  context "default actions" do

    it "should relentlessly remove br tags" do
      harry.fragment('<p>hello</p><br /><strong>HELLO</strong><br /><br />').to_s.should == '<p>hello</p><strong>HELLO</strong>'
    end

    context "removing blank tags" do

      TAGS_TO_REMOVE.each do |name,example|
        it "should automatically remove blank #{name} tags" do
          harry.fragment("#{example}<p>Hello!</p>").to_s.should == '<p>Hello!</p>'
        end
      end

    end

    context "inline tags to blocks" do

      it "should automatically change br to p" do
        harry.fragment( 'Hotel Details<br />' ).to_s.should == '<p>Hotel Details</p>'
      end

      it "should automatically change multiple br tags to a single p" do
        harry.fragment(  'Hotel Details<br /><br /><br />' ).to_s.should == '<p>Hotel Details</p>'
      end

      it "should automatically clear whitespace when converting line-style to block-style" do
         harry.fragment(  'hotel<br />        hostel      <br />').to_s.should == '<p>hotel</p><p>hostel</p>'
      end

      it "should automatically change all br tags to wrapped p tags" do
        harry.fragment( 'hotel<br /> hostel<br /> tent<br />').to_s.should == '<p>hotel</p><p>hostel</p><p>tent</p>'
      end

      it "should automatically change all multiple br tags to wrapped tags" do
        harry.fragment(  'hotel<br /><br /><br/> hostel<br /> tent<br />').to_s.should == '<p>hotel</p><p>hostel</p><p>tent</p>'
      end

      it "should automatically change leading inline tags to block tags" do
        harry.fragment(  '<br /><br />hotel').to_s.should == '<p>hotel</p>'
      end

      it "should ignore stray inline tags if they don't appear relevant to the context" do
        harry.fragment(  '<br /><br />hotel <br />hostel<br />').to_s.should == '<p>hotel</p><p>hostel</p>'
      end

    end

    context "de-duping" do

      it "should automatically de-dupe lists" do
        harry.fragment('<ul><li>Duplicate.</li></ul><ul><li>Duplicate.</li></ul>').to_s.should == '<ul><li>Duplicate.</li></ul>'
      end

      it "should automatically de-dupe paragraphs" do
        harry.fragment('<p>Lorem Ipsum</p><p>Lorem Ipsum</p>').to_s.should == '<p>Lorem Ipsum</p>'
      end

      it "should not remove duplicate content that exsists at a different markup level" do
        harry.fragment('<p><strong>Location:</strong></p><strong>Location:</strong>').to_s.should == '<p><strong>Location:</strong></p><strong>Location:</strong>'
      end

      it "should not alter other content when it de-dupes" do
        harry.fragment('<h3>Here</h3><p>Yep, here.</p><h3>Here</h3><p>Here again.</p>').to_s.should == '<h3>Here</h3><p>Yep, here.</p><p>Here again.</p>'
      end

      it "should de-dupe if the only content difference is whitespace" do
        pending "Too complicated for the first cut."
      end

    end

    context 'with default br processing overridden' do

      it 'does not remove br tags' do
        harry.fragment('<p>aa <br> bb</p>', :no_br_changes => true).to_s.should == '<p>aa <br> bb</p>'
      end

    end

  end

end
