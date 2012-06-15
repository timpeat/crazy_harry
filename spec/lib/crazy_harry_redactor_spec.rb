require 'spec_helper'

describe CrazyHarry::Redactor do

  #   Strip all tags  -- should convert </p> and <br> to linebreaks by default
  #   Strip tags from text: "HostelWorld"
  #   Strip tags from text: "HostelWorld" inside h3
  #
  #   ADS suggested ability to remove tag and content, so 'kill'  Probably
  #   more appropriate for script and image tags
  #
  #   Kill a where a has attribute: "nofollow", text: "visit Disneyland"
  #   Kill script
  #   Kill img

  subject { CrazyHarry::Redactor }


end
