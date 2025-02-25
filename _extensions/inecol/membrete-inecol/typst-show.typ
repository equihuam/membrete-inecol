#show: membrete-inecol.with(

    titulo: "$titulo$",
    contactoemail: "$contactoemail$",
    contactotel: "$contactotel$",
    idioma: "$idioma$",
    logo: "$logo$",
    logoAncho: $logoAncho$,
    logoSubir: $logoSubir$,
    logoPie: "$logoPie$",
    firma: "$firma$",
    firmAncho: $firmAncho$,
    destinatario: ($for(destinatario)$"$destinatario$"$sep$, $endfor$),
    remitente: ($for(remitente)$"$remitente$"$sep$, $endfor$),
    apendice: "$apendice$",
    font: "$font$",
    font-tam: $font-size$,
    $if(title-size)$
    title-size: $title-tam$,
    $endif$
    paper: "$paper$",
    numerar: "$numbering$",
    numero-alinea: $number-align$,
    mtop: $margin.top$,
    mbottom: $margin.bottom$,
    mright: $margin.right$,
    mleft: $margin.left$,
    footer-pre: "$footer-pre$",
    fecha: "$fecha$",
    folio: "$foliio$",
    asunto: "$asunto$",
    tema: "$tema$",
    saludo: "$saludo$",
    despedida: "$despedida$",
    $if(copiapara)$
       copiapara: ($for(copiapara)$"$copiapara$"$sep$, $endfor$),
    $endif$
    $if(attachment)$
      anexo: ($for(attachment)$"$attachment$"$sep$, $endfor$),
    $endif$
)
