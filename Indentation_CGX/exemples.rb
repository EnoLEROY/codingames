require_relative "second_attempt"


a = [["' ab  ",
"  c'",
"\t true",
""],
["(0)"],
["( )"],
["((tr ue))"],
["(",
"    'menu'=",
"    (",
"        'id'= 'file';",
"        'test'=true;",
"        'test'=12;",
"        'value'= 'File';",
"        'popup'=",
"        (",
"            'menuitem'=",
"            (",
"                ( 'value'= 'New'; 'onclick'= 'CreateNewDoc()' );",
"                ( 'value'= 'Open'; 'onclick'= 'OpenDoc()' );",
"                ( 'value'= 'Close'; 'onclick'= 'CloseDoc()' )",
"            )",
"        ); ()",
"    )",
")"],

["(",
"    'menu'=",
"    (",
"        'id'= 'file';",
"        'value'= 'File';",
"        'popup'=",
"        (",
"            'menuitem'=",
"            (",
"                ( 'value'= 'New'; 'onclick'= 'CreateNewDoc()' );",
"                ( 'value'= 'Open'; 'onclick'= 'OpenDoc()' );",
"                ( 'value'= 'Close'; 'onclick'= 'CloseDoc()' )",
"            )",
"        ); ()",
"    )",
")"],
['(  ',
'  9       )']
]
a.each do |exemple|
  puts formating(exemple)
  
  puts "----------------------"
end

puts formating(a[2])


