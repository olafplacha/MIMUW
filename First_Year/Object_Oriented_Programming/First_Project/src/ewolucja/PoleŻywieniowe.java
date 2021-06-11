package ewolucja;

public class PoleŻywieniowe extends Pole {

    private int tura_ostatnio_zjedzono;

    protected PoleŻywieniowe(int ile_rośnie_jedzenie, int ile_daje_jedzenie) {
        super(ile_rośnie_jedzenie, ile_daje_jedzenie);
        this.tura_ostatnio_zjedzono = -ile_rośnie_jedzenie;
    }

    @Override
    public boolean oddajJedzenieJezeliJest(int tura, int ile_rośnie_jedzenie) {
        if (czyJestJedzenie(tura)) {
            tura_ostatnio_zjedzono = tura;
            return true;
        }
        return false;
    }

    @Override
    public boolean czyJestJedzenie(int tura) {
        // jedzenie zdążyło odrosnąć wtedy i tylko wtedy gdy ostatni posiłek miał
        // miejsce minimum ile_rośnie_jedzenie tur temu
        return tura_ostatnio_zjedzono + ile_rośnie_jedzenie <= tura;
    }

}
