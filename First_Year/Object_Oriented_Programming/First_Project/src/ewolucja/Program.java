package ewolucja;

import java.util.ArrayList;
import java.util.Random;

public class Program {
    private final ArrayList<Instrukcja> instrukcje;
    private final float koszt_tury;

    public Program(ArrayList<Instrukcja> spis_instrukcji, float koszt_tury) {
        this.instrukcje = spis_instrukcji;
        this.koszt_tury = koszt_tury;
    }

    public boolean wykonajProgram(Rob rob, int tura) {
        // zwraca true wtw gdy rob przeżyje turę
        if (!rob.zmniejszEnergię(koszt_tury)) return false;
        for (Instrukcja instrukcja : instrukcje) {
            instrukcja.wykonaj(rob, tura);
            if (!rob.zmniejszEnergię(1)) return false;
        }
        return true;
    }

    public Program mutuj(ArrayList<Instrukcja> spis_instr, float pr_usunięcia_instr, float pr_dodania_instr, float pr_zmiany_instr) {
        ArrayList<Instrukcja> płytka_kopia_instrukcji = new ArrayList<>(instrukcje);
        // próba usunięcia ostatniej instrukcji
        if (płytka_kopia_instrukcji.size() > 0 && Math.random() < pr_usunięcia_instr) {
            płytka_kopia_instrukcji.remove(płytka_kopia_instrukcji.size() - 1);
        }
        // próba dodania losowej instrukcji
        Random rand = new Random();
        if (Math.random() < pr_dodania_instr) {
            płytka_kopia_instrukcji.add(spis_instr.get(rand.nextInt(spis_instr.size())));
        }
        // próba zmiany losowej instrukcji
        if (płytka_kopia_instrukcji.size() > 0 && Math.random() < pr_zmiany_instr) {
            int losowy_index_docelowy = rand.nextInt(płytka_kopia_instrukcji.size());
            Instrukcja losowa_instrukcja = płytka_kopia_instrukcji.get(rand.nextInt(płytka_kopia_instrukcji.size()));
            płytka_kopia_instrukcji.set(losowy_index_docelowy, losowa_instrukcja);
        }
        return new Program(płytka_kopia_instrukcji, koszt_tury);
    }

    public int getDługośćProgramu() { return instrukcje.size(); }
}
