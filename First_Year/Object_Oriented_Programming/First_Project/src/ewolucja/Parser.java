package ewolucja;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Scanner;

public class Parser {
    private String ścieżka_do_planszy;
    private String ścieżka_do_paramterów;

    public Parser(String ścieżka_do_planszy, String ścieżka_do_paramterów) {
        this.ścieżka_do_planszy = ścieżka_do_planszy;
        this.ścieżka_do_paramterów = ścieżka_do_paramterów;
    }

    public ArrayList<boolean[]> wczytajPlanszę() {
        ArrayList<boolean[]> serializowana_plansza = new ArrayList<>();
        try {
            File plik = new File(ścieżka_do_planszy);
            Scanner skaner_pliku = new Scanner(plik);
            int liczba_pól_w_rzędzie = -1;

            while (skaner_pliku.hasNext()) {
                String linia = skaner_pliku.nextLine();
                if (!(linia.length() == liczba_pól_w_rzędzie || liczba_pól_w_rzędzie == -1)) {
                    throw new NiespójnaLiczbaPólWWierszach();
                }
                liczba_pól_w_rzędzie = linia.length();
                if (liczba_pól_w_rzędzie == 0) {
                    throw new BrakPólWWierszu();
                }
                boolean[] wiersz = new boolean[liczba_pól_w_rzędzie];

                int i = 0;
                for (char znak : linia.toCharArray()) {
                    if (znak == ' ') {
                        wiersz[i] = false;
                    }
                    else if (znak == 'x') {
                        wiersz[i] = true;
                    }
                    else {
                        throw new BłędnyZnakPlanszy();
                    }
                    i++;
                }
                serializowana_plansza.add(wiersz);
            }
            if (serializowana_plansza.size() == 0) {
                throw new BrakPól();
            }
            skaner_pliku.close();
        } catch (FileNotFoundException e) {
            System.out.println("Zła ścieżka do pliku!");
            e.printStackTrace();
        } catch (BłędnyZnakPlanszy e) {
            System.out.println("Plik z planszą zawiera niedozwolone znaki!");
            e.printStackTrace();
        } catch (NiespójnaLiczbaPólWWierszach e) {
            System.out.println("Zła liczba pól w rzędzie!");
            e.printStackTrace();
        } catch (BrakPólWWierszu e) {
            System.out.println("Co najmniej jeden wiersz jest pusty!");
            e.printStackTrace();
        } catch (BrakPól e) {
            System.out.println("Brak pól w pliku!");
            e.printStackTrace();

        }
        return serializowana_plansza;
    }

    public HashMap<String, String> wczytajParametry() throws FileNotFoundException, BłednyArgument {

        HashMap<String, String> paramtery = new HashMap<>();
        File plik = new File(ścieżka_do_paramterów);
        Scanner skaner_pliku = new Scanner(plik);
        while (skaner_pliku.hasNext()) {
            String linia = skaner_pliku.nextLine();
            String[] tokeny = linia.split(" ");
            if (tokeny.length < 2) throw new BłednyArgument();
            paramtery.put(tokeny[0], tokeny[1]);
        }
        skaner_pliku.close();
        return paramtery;
    }

}
