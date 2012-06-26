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

## Default Actions

It automatically removes blank tags, converts `<br \>` tags to wrapped
paragraphs and de-dupes content.  

## Chaining

As per the previous example, all calls *except* `.strip!` (which removes
all markup) may be chained.  

## Scoping and Targeting by Content

All commands except `.strip!` accept `scope:` and `text:` attributes:

    CrazyHarry.fragment( '<div><b>Hotels</b></div><p><b>Hotels</b></p><b>Tents</b>' ).change!( from: 'b', to: 'em', scope: 'p' ).to_s

will produce: 

    <div><b>Hotels</b></div><p><em>Hotels</em></p><b>Tents</b>

while:

    CrazyHarry.fragment( 'Hot <b>hotels</b> in <b>Saigon</b>' ).change!( from: 'b', to: 'em', text: 'hotels' ).to_s

will produce:

    Hot <em>hotels</em> in <b>Saigon</b>


## Adding Attributes

Use the `.translate` command to do this:

    harry.fragment( '<b>Header</b><p>Content</p>' ).translate!( add_attributes: { class: 'partner'} ).to_s

will return:

    <b class="partner">Header</b><p class="partner">Content</p>

If a tag already has an attribute, the new attribute will be appended to
the existing one:

    <b class="bright-red partner">Header</b><p class="partner">Content</p>

## Stripping

### Specific Tags

Use the `.redact!` command.  It *does not* strip unsafe tags by default.
To do this, pass the `unsafe: true` option.

### All Tags

Use the `.strip!` command.  It can be used as the last tag in a chain
(with `.translate( from_text: <some text>, to_text: <other text> )`, for instance), but should generally be the only call
you make. 

## Text Translation 

The `.translate!` command can change tag content, preserving case:

    CrazyHarry.fragment( '<h3>Lodging</h3> lodging' ).translate!( from_text: 'lodging', to_text: 'hotel' ).to_s

will return:
 
    <h3>Hotel</h3> lodging

## Known Issues

De-duping does not take account of whitespace.  So, `<p>Some
Content</p>` and `<p>Some Content </p>` will not be treated as
duplicates.

It may be useful to be able to turn off default actions.  
