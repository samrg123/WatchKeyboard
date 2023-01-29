import java.util.Collections;
import java.util.Arrays;
import java.util.Random;


class Phrases {

    private String[] phrases; //contains all of the phrases

    private int currentIndex;
    private int numTrials;

    public Phrases(int numTrials) {

        //load the phrase set into memory
        phrases = loadStrings("phrases2.txt"); 
        assert(numTrials < phrases.length);        

        //randomize the order of the phrases
        // Collections.shuffle(Arrays.asList(phrases), new Random());
        Collections.shuffle(Arrays.asList(phrases), new Random(100));
    
        currentIndex = 0;
   }

    public String currentPhrase() {
        return phrases[currentIndex];
    }

    public void advance() {
        currentIndex = (++currentIndex) % numTrials;
    }

    public void draw(String debug_text) {

        translate(0, 0);        
        textAlign(LEFT);

        //draw the trial count
        fill(128);
        text("Phrase " + (currentIndex+1) + " of " + numTrials, 70, 50);
        
        //draw the target string
        fill(128);
        text("Target:   " + currentPhrase(), 70, 100);

        fill(128);
        text(debug_text, 70, 150);
    }

}
