package ewolucja;

public abstract class Pole {
    protected final int ile_rośnie_jedzenie;
    private final int ile_daje_jedzenie;
    abstract boolean oddajJedzenieJezeliJest(int tura, int ile_rośnie_jedzenie);
    abstract boolean czyJestJedzenie(int tura);

    protected Pole(int ile_rośnie_jedzenie, int ile_daje_jedzenie) {
        this.ile_rośnie_jedzenie = ile_rośnie_jedzenie;
        this.ile_daje_jedzenie = ile_daje_jedzenie;
    }

    public int dajEnergięZJedzenia(int tura) {
        return oddajJedzenieJezeliJest(tura, ile_rośnie_jedzenie) ? ile_daje_jedzenie : 0;
    }
}
