package ewolucja;

public class Prawo implements Instrukcja {
    @Override
    public void wykonaj(Rob rob, int tura) {
        Rob.obrótWPrawo(rob);
    }
}
