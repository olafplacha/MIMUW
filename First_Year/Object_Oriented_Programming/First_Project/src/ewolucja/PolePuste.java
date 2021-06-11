package ewolucja;

public class PolePuste extends Pole {

    protected PolePuste(int ile_rośnie_jedzenie, int ile_daje_jedzenie) {
        super(ile_rośnie_jedzenie, ile_daje_jedzenie);
    }

    @Override
    boolean oddajJedzenieJezeliJest(int tura, int ile_rośnie_jedzenie) {
        return false;
    }

    @Override
    boolean czyJestJedzenie(int tura) {
        return false;
    }
}
