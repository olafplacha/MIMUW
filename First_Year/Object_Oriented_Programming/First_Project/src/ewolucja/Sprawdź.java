package ewolucja;

public class Sprawdź implements Instrukcja {
    private Plansza plansza;

    public Sprawdź(Plansza plansza) {
        this.plansza = plansza;
    }

    @Override
    public void wykonaj(Rob rob, int tura) {
        int sprawdźX;
        int sprawdźY;
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                if (!(i == 1 && j == 1)) {
                    // nie chcemy sprawdzać obecnego pola
                    sprawdźX = Math.floorMod(rob.getWspółrzędnaX() + i - 1, plansza.getRozmiar_planszy_x());
                    sprawdźY = Math.floorMod(rob.getWspółrzędnaY() + j - 1, plansza.getRozmiar_planszy_y());
                    if (plansza.czyPoleMaJedzenie(sprawdźX, sprawdźY, tura)) {
                        rob.setWspółrzędnaX(sprawdźX);
                        rob.setWspółrzędnaY(sprawdźY);
                        plansza.dajRobowiZjeść(rob, sprawdźX, sprawdźY, tura);
                        return;
                    }
                }
            }

        }
    }

}
