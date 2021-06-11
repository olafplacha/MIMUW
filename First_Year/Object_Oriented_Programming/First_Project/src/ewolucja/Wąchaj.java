package ewolucja;

public class Wąchaj implements Instrukcja {
    private Plansza plansza;

    public Wąchaj(Plansza plansza) {
        this.plansza = plansza;
    }

    @Override
    public void wykonaj(Rob rob, int tura) {
        for (int i = 0; i < 4; i++) {
            Rob.obrótWLewo(rob);
            if (sprawdźCzyJestJedzenieObok(i, rob.getWspółrzędnaX(), rob.getWspółrzędnaY(), tura)) return;
        }
    }

    private boolean sprawdźCzyJestJedzenieObok(int licznikObrotu, int x, int y, int tura) {
        int[] przesunięcia = {0, -1, 0, 1};
        int xWąchaj;
        int yWąchaj;
        xWąchaj = Math.floorMod(x + przesunięcia[licznikObrotu], plansza.getRozmiar_planszy_x());
        yWąchaj = Math.floorMod(y + przesunięcia[Math.floorMod(licznikObrotu - 1, 4)], plansza.getRozmiar_planszy_y());
        return plansza.czyPoleMaJedzenie(xWąchaj, yWąchaj, tura);
    }
}
