# Crazy Harry

A gem for blowing up bad html in partner fragments.

## Usage

  lodgings.each do |l|

    if descriptions[l.external_id]
      sanitised_fragment = CrazyHarry.fragment(descriptions[l.external_id])
        .redact!( unsafe: true,     tags: 'img')
        .change!( from: 'b',        to: 'h3' )
        .change!( from: 'strong',   to: 'h3' )

      l.update_column(:description, sanitised_fragment.to_s)
    end
  end

## Known issues

 * It should probably be able to unwrap stand-alone headers from
   paragraphs:

    `<p><b>I'm supposed to be a header</b></p>`

  should become:

    `<h3>I'm supposed to be a header</h3>`

  not:
  
    `<p><h3>I'm supposed to be a header</h3></p>`
