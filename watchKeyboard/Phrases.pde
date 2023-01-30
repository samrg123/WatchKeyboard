import java.util.Collections;
import java.util.Arrays;
import java.util.Random;


class Phrases {

    private String[] phrases; //contains all of the phrases

    private int numTrials;
    private int currentIndex;

    public Phrases(int numTrials) {

        this.numTrials = numTrials;
        currentIndex = 0;

        //load the phrase set into memory
        phrases = loadStrings("phrases2.txt");
        assert(numTrials < phrases.length);    

        //randomize the order of the phrases
        Collections.shuffle(Arrays.asList(phrases), new Random());
    }

    public int getTrialNumber() {
        return currentIndex;
    }

    public int getNumTrials() {
        return numTrials;
    }

    public String currentPhrase() {
        return phrases[currentIndex];
    }

    public boolean nextPhrase() {

        if(++currentIndex < numTrials) return true;
        
        currentIndex = numTrials-1;
        return false;
    }

    public void draw(String debug_text) {

        textAlign(LEFT);

        //draw the trial count
        fill(128);
        text("Phrase " + (currentIndex+1) + " of " + numTrials, 70, 50);
        
        //draw the target string
        fill(128);
        text("Target:   " + currentPhrase(), 70, 100);

        fill(128);

        // TODO: text doesn't support newlines? Add support for it
        text(debug_text, 70, 150);

    }

}
