
class BenchmarkResults {

    private float startTime;
    private float finishTime;
    private float lastTime;

    private int lettersEnteredTotal;  //a running total of the number of letters the user has entered (need this for final WPM computation)
    private int lettersExpectedTotal; //a running total of the number of letters expected (correct phrases)
    private int errorsTotal;          //a running total of the number of errors (when hitting next)


    public float getTotalTimeMS() {
        if(startTime == 0) return 0;
        return millis() - startTime;
    }

    public void start() {
        startTime = millis();
        lastTime = startTime;
    }

    public void stop() {

        finishTime = millis();
        System.out.println("==================");
        System.out.println("Trials complete!"); //output
        System.out.println("Total time taken: " + (finishTime - startTime)/1000 + "s"); //output
        System.out.println("Total letters entered: " + lettersEnteredTotal); //output
        System.out.println("Total letters expected: " + lettersExpectedTotal); //output
        System.out.println("Total errors entered: " + errorsTotal); //output

        float wpm = (lettersEnteredTotal/5.0f)/((finishTime - startTime)/60000f); //FYI - 60K is number of milliseconds in minute
        float freebieErrors = lettersExpectedTotal*.05; //no penalty if errors are under 5% of chars
        float penalty = max(errorsTotal-freebieErrors, 0) * .5f;

        System.out.println("Raw WPM: " + wpm); //output
        System.out.println("Freebie errors: " + freebieErrors); //output
        System.out.println("Penalty: " + penalty);
        System.out.println("WPM w/ penalty: " + (wpm-penalty)); //yes, minus, becuase higher WPM is better
        System.out.println("==================");
    }

    public void reset() {
        startTime = 0;
        finishTime = 0;
        lettersEnteredTotal = 0;
        lettersExpectedTotal = 0;
        errorsTotal = 0;
    }

    public BenchmarkResults() {
        reset();
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

    public void addResults(String typedString, String targetPhrase) {

        System.out.println("==================");
        // System.out.println("Phrase " + (currTrialNum+1) + " of " + totalTrialNum); //output
        System.out.println("Target phrase: " + targetPhrase); //output
        System.out.println("Phrase length: " + targetPhrase.length()); //output
        System.out.println("User typed: " + typedString); //output
        System.out.println("User typed length: " + typedString.length()); //output
        System.out.println("Number of errors: " + computeLevenshteinDistance(typedString.trim(), targetPhrase.trim())); //trim whitespace and compute errors
        System.out.println("Time taken on this trial: " + (millis()-lastTime)); //output
        System.out.println("Time taken since beginning: " + (millis()-startTime)); //output
        System.out.println("==================");

        lettersExpectedTotal+=targetPhrase.trim().length();
        lettersEnteredTotal+=typedString.trim().length();
        errorsTotal+=computeLevenshteinDistance(typedString.trim(), targetPhrase.trim());

        lastTime = millis();
    }

    public void draw() {
        
        fill(255);
        textAlign(CENTER);
        
        float xOffset = 400;
        float yOffset = 200;
        float yStride = textAscent() + textDescent() + 10; 

        text("Trials complete!", xOffset, yOffset); yOffset+= yStride; //output
        text("Total time taken: " + (finishTime - startTime)/1000 + "s", xOffset, yOffset); yOffset+= yStride; //output
        text("Total letters entered: " + lettersEnteredTotal, xOffset, yOffset); yOffset+= yStride; //output
        text("Total letters expected: " + lettersExpectedTotal, xOffset, yOffset); yOffset+= yStride; //output
        text("Total errors entered: " + errorsTotal, xOffset, yOffset); yOffset+= yStride; //output

        float wpm = (lettersEnteredTotal/5.0f)/((finishTime - startTime)/60000f); yOffset+= yStride; //FYI - 60K is number of milliseconds in minute
        text("Raw WPM: " + wpm, xOffset, yOffset); yOffset+= yStride; //output

        float freebieErrors = lettersExpectedTotal*.05; //no penalty if errors are under 5% of chars
        text("Freebie errors: " + nf(freebieErrors, 1, 3), xOffset, yOffset); yOffset+= yStride; //output

        float penalty = max(errorsTotal-freebieErrors, 0) * .5f;
        text("Penalty: " + penalty, xOffset, yOffset); yOffset+= yStride; 
        text("WPM w/ penalty: " + (wpm-penalty), xOffset, yOffset); yOffset+= yStride; //yes, minus, because higher WPM is better        
    }
}

