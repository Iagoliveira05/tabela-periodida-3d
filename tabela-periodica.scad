include <BOSL2/std.scad>
$fn = 40;


dimensao = 100;
alturaBorda = 10;
borda = 10;
profundidade = 5;

alturaLetra = profundidade;
sigla = "Fr";
nomeELemento = "Hidrogênio";
numeroAtomico = "87";
massaAtomico = "(875)";
fonte = "Impact:style=Regular";


module borda() {
    color("#602") {
        linear_extrude(height=alturaBorda) {
            stroke(rect(dimensao, rounding=10), closed=true, width=7);
        }
    }
}

module preenchimento() {
    color("#035") {
        linear_extrude(height=alturaBorda-profundidade) {
            rect(dimensao, rounding=10);
        }
    }
}

module letras() {
	
    up(alturaBorda+(alturaLetra/2)-profundidade) {
        //sigla
        text3d(sigla, h=alturaLetra, size=35, anchor=CENTER, center=true, font=fonte);

        //nomeELemento
        fwd((dimensao/2) - 15) {
            text3d(nomeELemento, h=alturaLetra, size=10, anchor=CENTER, center=true, font=fonte);
        }

        //numeroAtomico
        back((dimensao/2) - 15) {
            left(dimensao/2 - 10) {
                text3d(numeroAtomico, h=alturaLetra, size=10, anchor=LEFT, center=true, font=fonte);
            }
        }

        //massaAtomico
        back((dimensao/2) - 15) {
            right(dimensao/2 - 10) {
                text3d(massaAtomico, h=alturaLetra, size=10, anchor=RIGHT, center=true, font=fonte);
            }
        }
    }
}



union() {
    preenchimento();
    borda();
    letras();
}



