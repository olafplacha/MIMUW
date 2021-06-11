package ewolucja;

public class Lewo implements Instrukcja {
    @Override
    public void wykonaj(Rob rob, int tura) {
        Rob.obrótWLewo(rob);
    }
}
