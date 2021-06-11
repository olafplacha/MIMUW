package ewolucja;

public class DoPrzodu implements Instrukcja {
    private Plansza plansza;

    public DoPrzodu(Plansza plansza) {
        this.plansza = plansza;
    }

    @Override
    public void wykonaj(Rob rob, int tura) {
        rob.doPrzodu(plansza.getRozmiar_planszy_x(), plansza.getRozmiar_planszy_y());
        plansza.dajRobowiZjeść(rob, rob.getWspółrzędnaX(), rob.getWspółrzędnaY(), tura);
    }
}
