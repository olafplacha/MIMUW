package ewolucja;

import java.lang.reflect.Array;
import java.util.ArrayList;

public class Plansza {
    private final int rozmiar_planszy_x;
    private final int rozmiar_planszy_y;
    private final Pole[][] pola;

    public Plansza(ArrayList<boolean[]> czyŻywieniowe,
                   int ile_rośnie_jedzenie, int ile_daje_jedzenie) {
        this.rozmiar_planszy_x = czyŻywieniowe.size();
        this.rozmiar_planszy_y = czyŻywieniowe.get(0).length;
        this.pola = new Pole[rozmiar_planszy_x][rozmiar_planszy_y];
        zbudujPola(czyŻywieniowe, ile_rośnie_jedzenie, ile_daje_jedzenie);
    }

    private void zbudujPola(ArrayList<boolean[]> czyŻywieniowe, int ile_rośnie_jedzenie, int ile_daje_jedzenie) {
        // na podstawie tablicy wartości logicznych zostanie stworzona tablica pól
        for (int i = 0; i < czyŻywieniowe.size(); i++) {
            for (int j = 0; j < czyŻywieniowe.get(i).length; j++) {
                if (czyŻywieniowe.get(i)[j]) {
                    pola[i][j] = new PoleŻywieniowe(ile_rośnie_jedzenie, ile_daje_jedzenie);
                }
                else {
                    pola[i][j] = new PolePuste(ile_rośnie_jedzenie, ile_daje_jedzenie);
                }
            }
        }
    }

    public int getLiczbaPólZŻywnością(int numer_tury) {
        int liczba_pól_z_żywnością = 0;
        for (int i = 0; i < pola.length; i++) {
            for (int j = 0; j < pola[i].length; j++) {
                if (pola[i][j].czyJestJedzenie(numer_tury)) liczba_pól_z_żywnością++;
            }
        }
        return liczba_pól_z_żywnością;
    }

    public int getRozmiar_planszy_x() {
        return rozmiar_planszy_x;
    }

    public int getRozmiar_planszy_y() {
        return rozmiar_planszy_y;
    }

    public void dajRobowiZjeść(Rob rob, int x, int y, int tura) {
        rob.zjedzToCoJestNaPolu(pola[x][y], tura);
    }

    public boolean czyPoleMaJedzenie(int x, int y, int tura) {
        return pola[x][y].czyJestJedzenie(tura);
    }
}
