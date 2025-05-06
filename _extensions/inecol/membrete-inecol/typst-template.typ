
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
