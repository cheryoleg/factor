USING: help.markup help.syntax words.constant ;
in: words.constant

ARTICLE: "words.constant" "Constants"
"There is a syntax for defining words which push literals on the stack."
$nl
"Define a new word that pushes a literal on the stack:"
{ $subsections postpone\ CONSTANT: }
"Define an constant at run-time:"
{ $subsections define-constant } ;

about: "words.constant"
