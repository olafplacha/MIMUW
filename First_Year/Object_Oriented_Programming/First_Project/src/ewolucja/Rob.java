package ewolucja;

import java.util.ArrayList;

public class Rob {

    private float energia;
    private final Program program;
    private final Położenie położenie;
    private int data_urodzenia;

    public Rob(float energia, Program program, int x, int y, Położenie.Kierunek kierunek) {
        this.energia = energia;
        this.program = program;
        this.położenie = new Położenie(kierunek, x, y);
        this.data_urodzenia = 0;
    }

    public Rob(float energia, Program program, int x, int y, Położenie.Kierunek kierunek, int data_urodzenia) {
        this.energia = energia;
        this.program = program;
        this.położenie = new Położenie(kierunek, x, y);
        this.data_urodzenia = data_urodzenia;
    }

    public boolean wykonajProgram(int tura) {
        program.wykonajProgram(this, tura);
        return energia >= 0;
    }

    public static class Położenie {
        public enum Kierunek {przód, tył, prawo, lewo};
        private Kierunek kierunek;
        private int x;
        private int y;

        public Położenie(Kierunek kierunek, int x, int y) {
            this.kierunek = kierunek;
            this.x = x;
            this.y = y;
        }
    }

    public void doPrzodu(int rozmiar_x, int rozmiar_y) {

        switch (położenie.kierunek) {
            case przód: położenie.y = Math.floorMod(położenie.y + 1, rozmiar_y); break;
            case tył: położenie.y = Math.floorMod(położenie.y - 1, rozmiar_y); break;
            case prawo: położenie.x = Math.floorMod(położenie.x + 1, rozmiar_x); break;
            case lewo: położenie.x = Math.floorMod(położenie.x - 1, rozmiar_x); break;
        }
    }

    public static void obrótWLewo(Rob rob) {
        Położenie położenie = rob.położenie;

        switch (położenie.kierunek) {
            case przód: położenie.kierunek = Położenie.Kierunek.lewo; break;
            case tył: położenie.kierunek = Położenie.Kierunek.prawo; break;
            case prawo: położenie.kierunek = Położenie.Kierunek.tył; break;
            case lewo: położenie.kierunek = Położenie.Kierunek.przód; break;
        }
    }

    public static void obrótWPrawo(Rob rob) {
        Położenie położenie = rob.położenie;

        obrótWLewo(rob);
        obrótWLewo(rob);
        obrótWLewo(rob);
    }

    public void zjedzToCoJestNaPolu(Pole pole, int tura) {
        energia += pole.dajEnergięZJedzenia(tura);
    }

    public boolean zmniejszEnergię(float ile) {
        // zwraca false wtw gdy energia roba jest mniejsza niż 0
        energia -= ile;
        return energia >= 0;
    }

    public boolean czyBędzieMutował(int limit_powielania, float pr_powielenia) {
        return (energia >= limit_powielania && Math.random() < pr_powielenia);
    }

    public Rob mutuj(ArrayList<Instrukcja> spis_instr, float pr_usunięcia_instr, float pr_dodania_instr,
                     float pr_zmiany_instr, float ułamek_energii_rodzica, int numer_tury) {
        Program nowy_program = program.mutuj(spis_instr, pr_usunięcia_instr, pr_dodania_instr, pr_zmiany_instr);

        // rodzic oddaje część swojej energii
        float energia_dziecka = this.energia * ułamek_energii_rodzica;
        this.energia *= (1 - ułamek_energii_rodzica);

        Rob dziecko = new Rob(energia_dziecka, nowy_program, położenie.x, położenie.y, położenie.kierunek, numer_tury);
        Rob.obrótWLewo(dziecko);
        Rob.obrótWLewo(dziecko);
        return dziecko;
    }

    @Override
    public String toString() {
        return "energia=" + energia +
                ", x=" + położenie.x +
                ", y=" + położenie.y +
                ", kierunek=" + położenie.kierunek;
    }

    public float getEnergiaRoba() { return energia; }

    public int getWiekRoba(int numer_tury) { return numer_tury - data_urodzenia; }

    public int getDługośćProgramuRoba() { return program.getDługośćProgramu(); }

    public int getWspółrzędnaX() {
        return położenie.x;
    }

    public int getWspółrzędnaY() {
        return położenie.y;
    }

    public void setWspółrzędnaX(int x) {
        położenie.x = x;
    }

    public void setWspółrzędnaY(int y) {
        położenie.y = y;
    }

}
