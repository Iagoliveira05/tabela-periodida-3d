include <BOSL2/std.scad>
$fn = 60;

/* [Elemento] */
sigla = "Fr";
nomeELemento = "Frâncio";
numeroAtomico = "87";
massaAtomico = "(223)";

/* [Família do Elemento] */
// 0=Nenhum, 1=Metais Alcalinos, 2=Metais Alcalinos Terrosos, 3=Metais de Transição, 4=Ametais, 5=Semi Metais, 6=Outros Metais, 7=Lantanídeos, 8=Actinídeos, 9=Halogênios, 10=Gases Nobres, 11=Hidrogênio
familia = 1;

/* [Dimensões] */
dimensao = 100;
alturaBorda = 7;
profundidade = 3;

/* [Cores] */
corBorda = "#602";
corFundo = "#085";

// ─────────────────────────────────────────
// Configurações internas
// ─────────────────────────────────────────
alturaLetra    = profundidade;
fonte          = "Anton";

iconeTamanho   = 14;    // diâmetro / lado em mm
iconeEspessura = 2.2;   // espessura do contorno
iconeAltura    = alturaBorda; // mesmo height da borda, parte de Z=0

// Centralizado na borda esquerda
iconeCentroX   = -(dimensao/2) + 18;
iconeCentroY   = 0;

function familia_info(f) =
    f == 1  ? ["Metais Alcalinos",          "#C0392B"] :
    f == 2  ? ["Metais Alcalinos Terrosos", "#E67E22"] :
    f == 3  ? ["Metais de Transição",       "#F1C40F"] :
    f == 4  ? ["Ametais",                   "#2980B9"] :
    f == 5  ? ["Semi Metais",               "#16A085"] :
    f == 6  ? ["Outros Metais",             "#27AE60"] :
    f == 7  ? ["Lantanídeos",               "#D35400"] :
    f == 8  ? ["Actinídeos",                "#7F8C8D"] :
    f == 9  ? ["Halogênios",                "#8E44AD"] :
    f == 10 ? ["Gases Nobres",              "#1ABC9C"] :
    f == 11 ? ["Hidrogênio",                "#2C3E50"] :
              ["",                          "#444444"];

// ─────────────────────────────────────────
// Módulos base
// ─────────────────────────────────────────
module borda() {
    color(corBorda)
        linear_extrude(height=alturaBorda)
            stroke(rect(dimensao, rounding=10), closed=true, width=7);
}

module preenchimento() {
    color(corFundo)
        linear_extrude(height=alturaBorda - profundidade)
            rect(dimensao, rounding=10);
}

module letras() {
    up(alturaBorda + (alturaLetra/2) - profundidade) {
        text3d(sigla, h=alturaLetra, size=35, anchor=CENTER, center=true, font=fonte);

        fwd((dimensao/2) - 15)
            text3d(nomeELemento, h=alturaLetra, size=10, anchor=CENTER, center=true, font=fonte);

        back((dimensao/2) - 17)
            left(dimensao/2 - 10)
                text3d(numeroAtomico, h=alturaLetra, size=14, anchor=LEFT, center=true, font=fonte);

        back((dimensao/2) - 19)
            right(dimensao/2 - 10)
                text3d(massaAtomico, h=alturaLetra, size=10, anchor=RIGHT, center=true, font=fonte);
    }
}

// ─────────────────────────────────────────
// Wrapper: posiciona e extrusiona o ícone
// Z começa em 0, sobe até alturaBorda
// ─────────────────────────────────────────
module icone_render(cor) {
    color(cor)
        translate([iconeCentroX, iconeCentroY, 0])
            linear_extrude(height=iconeAltura)
                children();
}

// ─────────────────────────────────────────
// Formas 2D — apenas contorno
// ─────────────────────────────────────────

// 1 – Metais Alcalinos → Quadrado vazado
module shape_quadrado() {
    difference() {
        square(iconeTamanho, center=true);
        square(iconeTamanho - iconeEspessura*2, center=true);
    }
}

// 2 – Metais Alcalinos Terrosos → Círculo vazado
module shape_circulo() {
    difference() {
        circle(r=iconeTamanho/2);
        circle(r=iconeTamanho/2 - iconeEspessura);
    }
}

// 3 – Metais de Transição → Triângulo vazado
module shape_triangulo() {
    r = iconeTamanho / 2;
    pts_e = [[0,r], [-r*sin(60),-r*cos(60)], [r*sin(60),-r*cos(60)]];
    ri = r - iconeEspessura*1.5;
    pts_i = [[0,ri],[-ri*sin(60),-ri*cos(60)],[ri*sin(60),-ri*cos(60)]];
    difference() { polygon(pts_e); polygon(pts_i); }
}

// 4 – Ametais → Losango vazado
module shape_losango() {
    r = iconeTamanho / 2;
    ri = r - iconeEspessura*1.4;
    difference() {
        polygon([[0,r],[-r,0],[0,-r],[r,0]]);
        polygon([[0,ri],[-ri,0],[0,-ri],[ri,0]]);
    }
}

// 5 – Semi Metais → Pentágono vazado
module shape_pentagono() {
    difference() {
        circle(r=iconeTamanho/2,   $fn=5);
        circle(r=iconeTamanho/2 - iconeEspessura, $fn=5);
    }
}

// 6 – Outros Metais → Hexágono vazado
module shape_hexagono() {
    difference() {
        circle(r=iconeTamanho/2,   $fn=6);
        circle(r=iconeTamanho/2 - iconeEspessura, $fn=6);
    }
}

// 7 – Lantanídeos → Estrela de 6 pontas vazada
module shape_estrela6() {
    n = 6;
    re = iconeTamanho/2;
    ri = re * 0.5;
    function pts(e,i) = [for(k=[0:2*n-1])
        let(a=90+k*180/n, r=(k%2==0)?e:i) [r*cos(a),r*sin(a)]];
    difference() {
        polygon(pts(re, ri));
        polygon(pts(re - iconeEspessura, ri - iconeEspessura*0.5));
    }
}

// 8 – Actinídeos → Cruz vazada
module shape_cruz() {
    esp = iconeTamanho / 3;
    ei  = iconeEspessura;
    difference() {
        union() {
            square([iconeTamanho, esp], center=true);
            square([esp, iconeTamanho], center=true);
        }
        union() {
            square([iconeTamanho - ei*2, esp - ei*2], center=true);
            square([esp - ei*2, iconeTamanho - ei*2], center=true);
        }
    }
}

// 9 – Halogênios → Estrela de 5 pontas vazada
module shape_estrela5() {
    n = 5;
    re = iconeTamanho/2;
    ri = re * 0.38;
    function pts(e,i) = [for(k=[0:2*n-1])
        let(a=90+k*180/n, r=(k%2==0)?e:i) [r*cos(a),r*sin(a)]];
    difference() {
        polygon(pts(re, ri));
        polygon(pts(re - iconeEspessura, ri - iconeEspessura*0.35));
    }
}

// 10 – Gases Nobres → Octógono vazado
module shape_octagono() {
    difference() {
        circle(r=iconeTamanho/2,   $fn=8);
        circle(r=iconeTamanho/2 - iconeEspessura, $fn=8);
    }
}

// 11 – Hidrogênio → Seta para cima vazada
module shape_seta() {
    r  = iconeTamanho / 2;
    cw = r * 0.38;
    ei = iconeEspessura;
    pts_e = [[0,r],[-r,0],[-cw,0],[-cw,-r],[cw,-r],[cw,0],[r,0]];
    pts_i = [[0,r-ei*1.6],[-(r-ei),-ei*0.5],[-(cw-ei),-ei*0.5],
             [-(cw-ei),-(r-ei)],[(cw-ei),-(r-ei)],[(cw-ei),-ei*0.5],[(r-ei),-ei*0.5]];
    difference() { polygon(pts_e); polygon(pts_i); }
}

// ─────────────────────────────────────────
// Despacho
// ─────────────────────────────────────────
module icone_familia() {
    if (familia > 0) {
        info = familia_info(familia);
        cor  = info[1];
        if      (familia == 1)  icone_render(cor) shape_quadrado();
        else if (familia == 2)  icone_render(cor) shape_circulo();
        else if (familia == 3)  icone_render(cor) shape_triangulo();
        else if (familia == 4)  icone_render(cor) shape_losango();
        else if (familia == 5)  icone_render(cor) shape_pentagono();
        else if (familia == 6)  icone_render(cor) shape_hexagono();
        else if (familia == 7)  icone_render(cor) shape_estrela6();
        else if (familia == 8)  icone_render(cor) shape_cruz();
        else if (familia == 9)  icone_render(cor) shape_estrela5();
        else if (familia == 10) icone_render(cor) shape_octagono();
        else if (familia == 11) icone_render(cor) shape_seta();
    }
}

// ─────────────────────────────────────────
// Montagem final
// ─────────────────────────────────────────
union() {
    preenchimento();
    borda();
    letras();
    icone_familia();
}
