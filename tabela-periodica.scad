include <BOSL2/std.scad>

dimensao = 100;
alturaBorda = 10;
borda = 10;
profundidade = 5;

alturaLetra = 5;
sigla = "Fr";
nomeELemento = "Francium";
numeroAtomico = "87";
massaAtomico = "(875)";


module borda() {
    color("#900") {
        linear_extrude(height=alturaBorda) {
            stroke(rect(dimensao, rounding=10), closed=true, width=7);
        }
    }
}

module preenchimento() {
    color("#090") {
        linear_extrude(height=profundidade) {
            rect(dimensao, rounding=10);
        }
    }
}

module letras() {
    up(profundidade+(alturaLetra/2)) {
        //sigla
        text3d(sigla, h=alturaLetra, size=35, anchor=CENTER, center=true, font=":style=bold");

        //nomeELemento
        fwd((dimensao/2) - 15) {
            text3d(nomeELemento, h=alturaLetra, size=10, anchor=CENTER, center=true, font=":style=bold");
        }

        //numeroAtomico
        back((dimensao/2) - 15) {
            left(dimensao/2 - 10) {
                text3d(numeroAtomico, h=alturaLetra, size=10, anchor=LEFT, center=true, font=":style=bold");
            }
        }

        //massaAtomico
        back((dimensao/2) - 15) {
            right(dimensao/2 - 10) {
                text3d(massaAtomico, h=alturaLetra, size=10, anchor=RIGHT, center=true, font=":style=bold");
            }
        }
    }
}

preenchimento();
borda();
letras();











