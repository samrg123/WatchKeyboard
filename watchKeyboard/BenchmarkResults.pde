
class BenchmarkResults {

    public float startTime;
    public float finishTime;

    public int lettersEnteredTotal;  //a running total of the number of letters the user has entered (need this for final WPM computation)
    public int lettersExpectedTotal; //a running total of the number of letters expected (correct phrases)
    public int errorsTotal;          //a running total of the number of errors (when hitting next)

    public void Reset() {
        startTime = 0;
        finishTime = 0;
        lettersEnteredTotal = 0;
        lettersExpectedTotal = 0;
        errorsTotal = 0;
    }

    public BenchmarkResults() {
        Reset();
    }

    //this computes error between two strings
    //=========SHOULD NOT NEED TO TOUCH THIS METHOD AT ALL!==============
    public int computeLevenshteinDistance(String phrase1, String phrase2) {
        
        int[][] distance = new int[phrase1.length() + 1][phrase2.length() + 1];

        for(int i = 0; i <= phrase1.length(); i++) distance[i][0] = i;
        for(int j = 1; j <= phrase2.length(); j++) distance[0][j] = j;

        for(int i = 1; i <= phrase1.length(); i++) {
            for(int j = 1; j <= phrase2.length(); j++) {

                distance[i][j] = min(
                    min(distance[i - 1][j] + 1, distance[i][j - 1] + 1), 
                    distance[i - 1][j - 1] + ((phrase1.charAt(i - 1) == phrase2.charAt(j - 1)) ? 0 : 1)
                );
            }
        }

        return distance[phrase1.length()][phrase2.length()];
    }    


    public void draw() {
        fill(0);
        textAlign(CENTER);
        
        text("Trials complete!", 400, 200); //output
        text("Total time taken: " + (finishTime - startTime)/1000 + "s", 400, 230); //output
        text("Total letters entered: " + lettersEnteredTotal, 400, 260); //output
        text("Total letters expected: " + lettersExpectedTotal, 400, 290); //output
        text("Total errors entered: " + errorsTotal, 400, 320); //output

        float wpm = (lettersEnteredTotal/5.0f)/((finishTime - startTime)/60000f); //FYI - 60K is number of milliseconds in minute
        text("Raw WPM: " + wpm, 400, 350); //output

        float freebieErrors = lettersExpectedTotal*.05; //no penalty if errors are under 5% of chars
        text("Freebie errors: " + nf(freebieErrors, 1, 3), 400, 380); //output

        float penalty = max(errorsTotal-freebieErrors, 0) * .5f;
        text("Penalty: " + penalty, 400, 410);
        text("WPM w/ penalty: " + (wpm-penalty), 400, 440); //yes, minus, because higher WPM is better        
    }
}