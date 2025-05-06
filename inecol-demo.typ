// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text( size: 0.92em )
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = [
  #line(start: (25%,0%), end: (75%,0%))
]

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

// Some quarto-specific definitions.

#show raw.where(block: true): block.with(
    fill: luma(230), 
    width: 100%, 
    inset: 8pt, 
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.amount
  }
  return block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == "string" {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == "content" {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subrefnumbering: "1a",
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => numbering(subrefnumbering, n-super, quartosubfloatcounter.get().first() + 1))
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => {
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          }

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != "string" {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let old_title = old_title_block.body.body.children.at(2)

  // TODO use custom separator if available
  let new_title = if empty(old_title) {
    [#kind #it.counter.display()]
  } else {
    [#kind #it.counter.display(): #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block, 
    block_with_new_content(
      old_title_block.body, 
      old_title_block.body.body.children.at(0) +
      old_title_block.body.body.children.at(1) +
      new_title))

  block_with_new_content(old_callout,
    new_title_block +
    old_callout.body.children.at(1))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color, 
        width: 100%, 
        inset: 8pt)[#text(icon_color, weight: 900)[#icon] #title]) +
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: white, width: 100%, inset: 8pt, body))
      }
    )
}


// Inicialización
#let membrete-inecol(

    titulo: none,
    contactoemail: none,
    contactotel: none,
    logo: none,
    logoAncho: none,
    logoSubir: none,
    logo Pie: none,
    firma: none,
    firmAncho: none,
    apendice: none,
    idioma: none,
    font: none,
    font-tam: none,
    title-tam: none,
    paper: none,
    numerar: none,
    numero-alinea: none,
    mtop: none,
    mbottom: none,
    mleft: none,
    mright: none,
    footer-pre: none,
    fecha: none,
    folio: none,
    asunto: none,
    tema: none,
    saludo: none,
    despedida: none,
    destinatario: none,
    remitente: none,
    copiapara: none,
    anexo: none,
    
    // Contenido principal del documento
    body
) = {

  // Font base
  set text(font: "Noto Sans", 10pt)
  set text(lang: idioma)

  // sangría en listas
  set list(indent: 10pt)
  set enum(indent: 10pt)


  // Remplazo de patrones de "escape"
  //------------------------------------------
  let logo_path = logo.replace("\\", "")
  let logoPie_path = logoPie.replace("\\", "")
  let saludo = saludo.replace("~", " ")


  // Definición de colores (guindas)
  let HSNRGuinda1 = rgb("612C42")
  let HSNRGuinda2 = rgb("6a0f36")
  let HSNRGuinda3 = rgb("4D182A")

  // Color de los títulos (guinda)
  show heading.where(level: 1): it => block(
    // guinda claro nivel 1
    text(HSNRGuinda1, 16pt)[#v(3mm) #it.body
                    #v(2mm)]
  )

  show heading.where(level: 2): it => block(
    // guinda claro nivel 2
    text(HSNRGuinda2, 14pt)[#v(2mm) #it.body #v(1mm)]
  )

  show heading.where(level: 3): it => block(
    // guinda claro nivel 3
    text(HSNRGuinda2, 12pt)[#v(2mm) #it.body #v(1mm)]
  )

  show heading.where(level: 4): it => block(
    // guinda claro nivel 4
    text(HSNRGuinda2, 11pt)[#v(2mm) #it.body #v(1mm)]
  )

  // Color de los enlaces
  show link: set text(fill: rgb("6c932c"), weight: "bold", style: "oblique")
    
  // Define tamaño de página y márgenes
  let contactoemail = contactoemail.replace("\\", "")
  let contactotel = contactotel.replace("\\", "")
  
  set page(
      paper: paper,
      margin: (
          top: mtop,
          bottom: mbottom,
          left: mleft,
          right: mright
      ),
      numbering: numerar,
      number-align: numero-alinea,
      header: align(center)[#image(logo_path, width: logoAncho)],
      header-ascent: logoSubir,
      footer: block()[#align(center)[#image(logoPie_path, width: logoAncho)]
              #text(8pt, HSNRGuinda3)[
                    #v(-8.5mm) #h(42mm)
                    #contactoemail \- #contactotel]
              #align(right)[#text(9pt, HSNRGuinda3)[
                   página #context counter(page).display("1 de 1", both: true)
                   ]
                ]
              ]
  )

  // fecha

  v(-4mm)
  align(right)[#fecha]
  v(5mm)

  // Destinatario
  //------------
  if destinatario != "" [
      #set align(left)
      #box()[#text(10pt, weight: "bold")[#for e in destinatario [
                      #let e = e.replace("\\", "")
                      #let e = e.replace("~", " ")
                      #e #v(-2mm)
                      ]
                    #v(10mm)  
                  ]
             ]
          ] else [#v(-40mm)]

  //----------------------
  //---- Fin de los campos de domicilio


  // Asunto o título
  if asunto != "" [#text(10pt, weight: "bold")[#asunto: #tema] #v(5mm)]
  else [#v(-6mm)]

  if saludo != "" [#text()[#saludo:] #v(5mm)] else [#v(2mm)]
  

  if titulo != "" [#text(HSNRGuinda2, 16pt, weight: "bold")[#titulo] #v(2mm)]
  else [#v(-6mm)]

  // Parte principal del documento
  // Habilita texto justificado con sangría inicial y evita guiones 
  // al dividir palabras. 
  set align(left)
  set par(first-line-indent: 2em, justify: true)
  set text(hyphenate: false)
  body

  // Distancia
  v(5mm)

  block[#text()[#despedida]]

  if firma != "" [
    #let firma = firma.replace("\\", "")
    #image(firma, width: firmAncho)
    #v(-6mm)
  ] else [#v(6mm)]

  // Remitente
  set par(first-line-indent: 0em, justify: false)
  
  if remitente.len() != 0 [
    #let remnombre = remitente.at(0)
    #let remdatos = remitente.slice(1)
    #let remnombre = remnombre.replace(".~", ". ")

    #block[
       #v(5mm)
       #text(11pt, weight: "extrabold")[
         #remnombre
         #v(-2mm)]
         #text(9pt, weight: "regular")[
            #for rem in remdatos [
                #let rem = rem.replace("\\@", "@")
                #rem #v(-2mm)
              ]
          ]
      ]

  ] else [#v(-40mm)]

  //---------

  v(4mm)
  
  if copiapara != none [
     #if type(copiapara) == str [#text(8pt)[ccp: #copiapara #v(-1mm)]
      ] else [
       #text(8pt)[ccp: 
           #for ccp in copiapara [
                - #ccp]
                ]
     ]
  ]

  if anexo != none [
    #text(8pt)[Anexo(s):
        #for a in anexo [
          - #a
        ]
    ]
  ]
}
#show: membrete-inecol.with(
    titulo: "",
    contactoemail: "miguel.equihua\@inecol.mx",
    contactotel: "extensión 4306",
    idioma: "es",
    logo: "\_extensions/inecol/membrete-inecol/inecol-membrete.png",
    logoAncho: 190mm,
    logoSubir: 10mm,
    logoPie: "\_extensions/inecol/membrete-inecol/inecol-pie.png",
    firma: "",
    firmAncho: 165mm,
    destinatario: ("Dr.~Destinatario", "Área de Trabajo", "Institución"),
    remitente: ("Dr.~Remitente", "Carretera antigua a Coatepec 351", "91073 Xalapa, Veracruz, México", "Tel: +52 (228) 842 1800", "correo\@electronico.ejm"),
    apendice: "",
    font: "Times New Roman",
    font-tam: 11pt,
        paper: "us-letter",
    numerar: "1.",
    numero-alinea: center,
    mtop: 40mm,
    mbottom: 45mm,
    mright: 25mm,
    mleft: 25mm,
    footer-pre: "página",
    fecha: "Xalapa, Ver., 1, feberero 2025",
    folio: "",
    asunto: "Asunto",
    tema: "Tema Interesante para el Inecol",
    saludo: "Estimado Sr.~Destinatario",
    despedida: "Reciba un cordial saludo.",
           copiapara: ("alguien que debe saber de esto."),
              anexo: ("anexo 1", "anexo 2"),
    )


Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi sit amet lacus nec erat tristique posuere. Pellentesque et orci massa. Proin malesuada consequat orci a euismod. Vestibulum tincidunt augue vitae vestibulum rhoncus. Suspendisse quis erat et urna facilisis pellentesque. Sed convallis iaculis molestie. Suspendisse placerat massa in sollicitudin pharetra.

== Tema de interés
<tema-de-interés>
=== Explicación
<explicación>
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi sit amet lacus nec erat tristique posuere. Pellentesque et orci massa. Proin malesuada consequat orci a euismod. Vestibulum tincidunt augue vitae vestibulum rhoncus. Suspendisse quis erat et urna facilisis pellentesque. Sed convallis iaculis molestie.

+ Lorem ipsum dolor sit amet.
+ Consectetur adipiscing elit.
+ Morbi sit amet lacus nec erat tristique posuere.
