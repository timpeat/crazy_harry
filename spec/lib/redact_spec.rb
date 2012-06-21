require 'spec_helper'

describe CrazyHarry::Redact do

  #   Strip all tags  -- should convert </p> and <br> to linebreaks by default
  #   Strip tags from text: "HostelWorld"
  #   Strip tags from text: "HostelWorld" inside h3
  #
  #   ADS suggested ability to remove tag and content, so 'kill'  Probably
  #   more appropriate for script and image tags
  #
  #   Kill a where a has attribute: "nofollow", text: "visit Disneyland"
  #   Kill img

  let(:harry){ CrazyHarry }

  context "strip all tags" do 

    it "should be able to strip all tags" do
      harry.fragment( "<b>a</b>b<br /><h3>c</h3><img src='blah.jpg' />" ).strip!.should == "a\nb\n\nc\n"
    end

  end

  context "strip specific tags" do

    it "should be able to strip unsafe tags" do
      harry.fragment( 'Me steal <script>Cookie!</script>').redact!( unsafe: true ).to_s.should == 'Me steal'
      harry.fragment( 'What is that <bloog>thing</bloog>?').redact!( unsafe: true ).to_s.should == 'What is that ?'
    end

    it "should allow the unsafe strip method to be overridden (it prunes by default)" do
      fragment = 'Me steal <script>Cookie!</script>'
      harry.fragment( fragment).redact!( unsafe: :escape ).to_s.should == 'Me steal &lt;script&gt;Cookie!&lt;/script&gt;'
      harry.fragment( fragment).redact!( unsafe: :strip ).to_s.should == 'Me steal Cookie!'
    end

    it "should prune unsafe tags if called without any arguments" do
      harry.fragment( 'Me steal <script>Cookie!</script>').redact!.to_s.should == 'Me steal'
    end

    it "should raise an error if asked for an unknown strip method" do
      -> { harry.fragment( 'Any old thing').redact!( unsafe: 'magical_magic' ).to_s }.should raise_error(CrazyHarry::Redact::InvalidStripMethod)
    end

    it "should be able to strip a specific tag" do
      harry.fragment( '<b>Location:</b><p>Saigon</p>' ).redact!( tags: 'b' ).to_s.should == "Location: <p>Saigon</p>"
    end

    it "should strip every occurrence of a tag" do
      harry.fragment( '<b>Location:</b><p>Saigon</p><b>Rates:</b>' ).redact!( tags: 'b' ).to_s.should == "Location: <p>Saigon</p>Rates:"
    end

    it "should be able to strip multiple tags" do
      harry.fragment( '<b>One</b><p>Saigon <em>Plaza</em></p>').redact!( tags: %w(b em)).to_s.should == "One <p>Saigon Plaza </p>"
    end

    it "should close a paragraph tag early if the fragment has an illegally nested header tag" do
      harry.fragment( '<b>One</b><p>Saigon <h3>Plaza</h3></p>').redact!( tags: %w(b h3)).to_s.should == "One <p>Saigon </p>Plaza"
    end

    context "chaining and multiple arguments" do

      it "should be able to chain calls" do
        harry.fragment( '<b>Location:</b><script>Steal Cookie</script><em>Plaza</em>' ).redact!( tags: 'b' ).redact!( unsafe: true ).to_s.should ==
          'Location: <em>Plaza</em>'
      end

      it "should accept multiple, different commands in a single call" do
        harry.fragment( '<b>Location:</b><script>Steal Cookie</script><em>Plaza</em>' ).redact!( tags: 'b', unsafe: true ).to_s.should ==
          'Location: <em>Plaza</em>'
      end

    end

    context "whitespace and breaks" do

      it "shouldn't add excessive extra whitespace" do
        harry.fragment( '<b>Location: </b> <b>Prices:</b>' ).redact!( tags: 'b' ).to_s.should == 'Location: Prices:'
      end

      it "should add a newline after a stripped block element" do
        harry.fragment( '<h3>Location:</h3><p>Lorem ipsum</p>' ).redact!( tags: 'h3' ).to_s.should == "Location:\n<p>Lorem ipsum</p>"
      end

    end

    context "targeting and scope" do

      it "should allow strip to be targeted by the tag content" do
        harry.fragment( '<h3>Location:</h3><h3>Ho Chi Minh City</h3>' ).redact!( tags: 'h3', text: 'Location:' ).to_s.should ==
          "Location:\n<h3>Ho Chi Minh City</h3>"
      end

      it "should allow strip to be targeted by an attribute" do
        harry.fragment( '<h3 class="big">Big</h3><h3 class="red">Red</h3>').redact!( tags: 'h3', attributes: { class: 'red' } ).to_s.should ==
          '<h3 class="big">Big</h3>Red'
      end

      it "should be able to scope changes to specific blocks" do
        harry.fragment( '<div><b>Hotels</b></div><p><b>Hotels</b></p><b>Tents</b>' ).redact!( tags: 'b', scope: 'p' ).to_s.should ==
          '<div><b>Hotels</b></div><p>Hotels </p><b>Tents</b>'
      end

      it "should allow strip to be targeted and scoped" do
        harry.fragment( '<b>Location:</b><p><b>Big</b> <b>Bad</b> Hotel</p>' ).redact!( tags: 'b', scope: 'p', text: 'Big' ).to_s.should ==
          '<b>Location:</b><p>Big <b>Bad</b> Hotel</p>'
      end

    end

  end

  context 'pruning' do

    it 'should be able to prune a tag, removing the tag and its contents' do
      harry.fragment( 'I do not want <h3>Big</h3> images.').redact!( tags: 'h3', prune: true ).to_s.should == 'I do not want images.'
    end

  end

end
