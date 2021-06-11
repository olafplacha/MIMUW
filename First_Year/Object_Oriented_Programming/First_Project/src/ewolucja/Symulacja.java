package ewolucja;

import java.io.FileNotFoundException;
import java.util.*;
import java.util.stream.Collectors;

public class Symulacja {

    public static void main(String[] args) throws FileNotFoundException, BłednyArgument, BłędnaInstrukcja {
        // tworzenie parsera, który obsługuje czytanie z pliku
        Parser parser = new Parser(args[0], args[1]);
        HashMap<String, String> parametry = parser.wczytajParametry();

        Plansza plansza = stwórzPlanszę(parser, parametry);

        ArrayList<Instrukcja> spis_instrukcji = new ArrayList<Instrukcja>();
        spis_instrukcji.add(new Lewo());
        spis_instrukcji.add(new Prawo());
        spis_instrukcji.add(new DoPrzodu(plansza));
        spis_instrukcji.add(new Wąchaj(plansza));
        spis_instrukcji.add(new Sprawdź(plansza));

        ArrayList<Rob> wszystkie_roby = strórzRoby(parametry, plansza, spis_instrukcji);
        ArrayList<Rob> żywe_roby = new ArrayList<>(wszystkie_roby);


        wypiszStanyRobów(wszystkie_roby, 0);
        // rozpoczynamy symulację
        for (int i = 0; i < Integer.parseInt(parametry.get("ile_tur")); i++) {
            // roby wykonują swoje programy. Jeżeli rob nie przeżyje tej tury, to usuwamy go z listy żyjących robów
            int numer_tury = i;
            int żyjące = 0;
            ArrayList<Integer> umarłe_w_tej_turze = new ArrayList<>();
            for (int j = 0; j < wszystkie_roby.size(); j++) {
                if (wszystkie_roby.get(j) != null) {
                    żyjące++;
                    if (!wszystkie_roby.get(j).wykonajProgram(numer_tury)) {
                        // rob umiera
                        wszystkie_roby.set(j, null);
                        umarłe_w_tej_turze.add(żyjące - 1);
                    }
                }
            }
            // usuń roby które umarły w tej turze
            umarłe_w_tej_turze.sort(Comparator.reverseOrder());
            umarłe_w_tej_turze.stream().mapToInt(d -> d).forEach(żywe_roby::remove);

            if ((i + 1) % Integer.parseInt(parametry.get("co_ile_wypisz")) == 0) {
                wypiszStanyRobów(wszystkie_roby, i + 1);
            }
            // wykonaj próbę powielenia
            int liczba_żywych_robów = żywe_roby.size();
            for (int j = 0; j < liczba_żywych_robów; j++) {
                Rob rob = żywe_roby.get(j);
                if (rob.czyBędzieMutował(Integer.parseInt(parametry.get("limit_powielania")), Float.parseFloat(parametry.get("pr_powielenia")))) {
                    float pr_usunięcia_instr = Float.parseFloat(parametry.get("pr_usunięcia_instr"));
                    float pr_dodania_instr = Float.parseFloat(parametry.get("pr_dodania_instr"));
                    float pr_zmiany_instr = Float.parseFloat(parametry.get("pr_zmiany_instr"));
                    float ułamek_energii_rodzica = Float.parseFloat(parametry.get("ułamek_energii_rodzica"));
                    Rob dziecko = rob.mutuj(spis_instrukcji, pr_usunięcia_instr, pr_dodania_instr, pr_zmiany_instr, ułamek_energii_rodzica, i + 1);
                    żywe_roby.add(dziecko);
                    wszystkie_roby.add(dziecko);
                }
            }
            wypiszStanSymulacji(żywe_roby, plansza, i + 1);
        }
    }

    private static void wypiszStanSymulacji(ArrayList<Rob> roby, Plansza plansza, int numer_tury) {
        int liczba_robów = 0;
        for (Rob rob : roby) {
            if (rob != null) liczba_robów++;
        }

        int liczba_pól_z_żywnością = plansza.getLiczbaPólZŻywnością(numer_tury);

        List<Integer> długości_programów = roby.stream().map(Rob::getDługośćProgramuRoba).collect(Collectors.toList());
        int minimalna_długość_programu = długości_programów.stream().min(Integer::compareTo).orElse(0);
        int maksymalna_długość_programu = długości_programów.stream().max(Integer::compareTo).orElse(0);
        double średnia_długość_programu = długości_programów.stream().mapToDouble(d -> d).average().orElse(0.0);

        List<Float> energie_robów = roby.stream().map(Rob::getEnergiaRoba).collect(Collectors.toList());
        float minimalna_energia_robów = energie_robów.stream().min(Float::compareTo).orElse((float) 0.0);
        float maksymalna_energia_robów = energie_robów.stream().max(Float::compareTo).orElse((float) 0.0);
        double średnia_energia_robów = energie_robów.stream().mapToDouble(d -> d).average().orElse(0.0);

        List<Integer> lata_robów = roby.stream().map(d -> d.getWiekRoba(numer_tury)).collect(Collectors.toList());
        int minimalny_wiek_roba = lata_robów.stream().min(Integer::compareTo).orElse(0);
        int maksymalny_wiek_roba = lata_robów.stream().max(Integer::compareTo).orElse(0);
        double średni_wiek_roba = lata_robów.stream().mapToDouble(d -> d).average().orElse(0.0);

        System.out.println(numer_tury + ", rob: " + liczba_robów + ", żyw: " + liczba_pól_z_żywnością +
                ", prg: " + minimalna_długość_programu + "/" + średnia_długość_programu + "/" + maksymalna_długość_programu +
                ", energ: " + minimalna_energia_robów + "/" + średnia_energia_robów + "/" + maksymalna_energia_robów +
                ", wiek: " + minimalny_wiek_roba + "/" + średni_wiek_roba + "/" + maksymalny_wiek_roba);
    }

    private static void wypiszStanyRobów(ArrayList<Rob> roby, int numer_tury) {
        System.out.println("Stany robów po " + numer_tury + " turze:");
        for (int i = 0; i < roby.size(); i++) {
            if (roby.get(i) == null) {
                System.out.println("Rob o nr: " + i + " nie żyje");
            } else {
                System.out.println("Rob o nr: " + i + " - " + roby.get(i).toString());
            }
        }
    }

    private static ArrayList<Rob> strórzRoby(HashMap<String, String> parametry, Plansza plansza, ArrayList<Instrukcja> spis_instrukcji) throws BłędnaInstrukcja {
        // generowanie początkowego programu
        ArrayList<Instrukcja> instrukcje = new ArrayList<>();
        for (char instrukcja : parametry.get("pocz_prog").toCharArray()) {
            switch (instrukcja) {
                case 'l': instrukcje.add(spis_instrukcji.get(0)); break;
                case 'p': instrukcje.add(spis_instrukcji.get(1)); break;
                case 'i': instrukcje.add(spis_instrukcji.get(2)); break;
                case 'w': instrukcje.add(spis_instrukcji.get(3)); break;
                case 'j': instrukcje.add(spis_instrukcji.get(4)); break;
                default: throw new BłędnaInstrukcja();
            }
        }
        ArrayList<Rob> roby = new ArrayList<>();

        for (int i = 0; i < Integer.parseInt(parametry.get("pocz_ile_robów")); i++) {
            // każdy rob będzie miał swoją płytką kopię instrukcji
            ArrayList<Instrukcja> instrukcje_roba = new ArrayList<>(instrukcje);
            Program program = new Program(instrukcje_roba, Float.parseFloat(parametry.get("koszt_tury")));

            // losowanie współrzędnych początkowych roba
            Random rand = new Random();
            int x = rand.nextInt(plansza.getRozmiar_planszy_x());
            int y = rand.nextInt(plansza.getRozmiar_planszy_y());
            // losowanie kierunku początkowego roba
            Rob.Położenie.Kierunek[] kierunki= Rob.Położenie.Kierunek.values();
            Rob.Położenie.Kierunek kierunek = kierunki[rand.nextInt(kierunki.length)];
            // tworzenie nowego roba i dodanie go do setu żyjących
            roby.add(new Rob(Float.parseFloat(parametry.get("pocz_energia")), program, x, y, kierunek));
        }
        return roby;
    }

    private static Plansza stwórzPlanszę(Parser parser, HashMap<String, String> parametry) throws FileNotFoundException, BłednyArgument {

        ArrayList<boolean[]> serializowana_plansza = parser.wczytajPlanszę();

        // generowanie planszy
        Plansza plansza = new Plansza(serializowana_plansza, Integer.parseInt(parametry.get("ile_rośnie_jedzenie")),
                Integer.parseInt(parametry.get("ile_daje_jedzenie")));

        return plansza;
    }

}
