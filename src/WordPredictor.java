import java.util.Comparator;
import java.util.PriorityQueue;
import java.util.List;
import java.util.ArrayList;
import java.io.*;  
import java.util.Scanner;  

class WordFrequency {
    public String word;
    public int frequency;

    WordFrequency(String word, int frequency) {
        this.word = word;
        this.frequency = frequency;
    }
}

class TrieNode {

    // R links to node children
    private TrieNode[] links;

    private final int R = 26;

    private boolean isEnd = false;

    private int frequency = 0;

    private int depth = 0;

    public TrieNode() {
        links = new TrieNode[R];
    }

    public boolean isLeaf() {
        for (int i = 0; i < R; i++) {
            if (links[i] != null) {
                return false;
            }
        }
        return true;
    }
    public boolean containsKey(char ch) {
        return links[ch -'a'] != null;
    }
    public boolean containsKey(int i) {
        return links[i] != null;
    }
    public TrieNode get(char ch) {
        return links[ch -'a'];
    }
    public TrieNode get(int i) {
        return links[i];
    }
    public int getFrequency() {
        return frequency;
    }
    public void put(char ch, TrieNode node) {
        links[ch -'a'] = node;
    }
    public void put(char ch, TrieNode node, int frequency) {
        links[ch -'a'] = node;
        links[ch-'a'].frequency = frequency;
    }
    public void putFrequency(int frequency) {
        this.frequency = frequency;
    }
    public void setEnd() {
        isEnd = true;
    }
    public boolean isEnd() {
        return isEnd;
    }
    public int getDepth() {
        return depth;
    }
    public void setDepth(int depth) {
        this.depth = depth;
    }
}

class Trie {
    private TrieNode root;

    public Trie() {
        root = new TrieNode();
    }

    // Inserts a word into the trie.
    public void insert(String word, int frequency) {
        TrieNode node = root;
        for (int i = 0; i < word.length(); i++) {
            char currentChar = word.charAt(i);
            if (!node.containsKey(currentChar)) {
                node.put(currentChar, new TrieNode(), frequency);
            }
            if (frequency > node.getFrequency()) {
                node.putFrequency(frequency);
            }
            node = node.get(currentChar);
        }
        node.setEnd();
    }

    public int assignDepthHelper(TrieNode node) {
        if (node.isLeaf()) {
            return 1;
        }
        int depth = -1;
        for (int i = 0; i < 26; i++) {
            if (node.containsKey(i)) {
                int tmp_depth = assignDepthHelper(node.get(i));
                if (tmp_depth > depth) {
                    depth = tmp_depth;
                }
                node.setDepth(depth);
            }
        }
        return depth + 1;
    }

    public void assignDepth() {
        assignDepthHelper(root);
    }

    // public int getFrequency(String word) {
    //     TrieNode node = root;
    //     for (int i = 0; i < word.length(); i++) {
    //         char curLetter = word.charAt(i);
    //         if (node.containsKey(curLetter)) {
    //             node = node.get(curLetter);
    //         }
    //         else {
    //             return 0;
    //         }
    //     }
    //     return node.getFrequency();
    // }

    private static double sigmoid(double x)
    {
        return 1 / (1 + Math.exp(-x));
    }

    public String findMaxFreq(String prefix) {
        TrieNode node = root;
        for (int i = 0; i < prefix.length(); i++) {
            char curLetter = prefix.charAt(i);
            if (node.containsKey(curLetter)) {
                node = node.get(curLetter);
            }
            else {
                return prefix;
            }
        }
        String ret = prefix;
        int length_multiplier = 1;
        while (node.isEnd() == false) {
            char letter = 'a';
            double frequency_weight = -1;
            System.out.println("#");
            for (int i = 0; i < 26; i++) {
                if (node.containsKey(i)) {
                    double local_frequency_weight = node.get(i).getFrequency() * sigmoid((- 1.3 * node.get(i).getDepth() + 5));
                    System.out.println((char)('a' + i));
                    System.out.println(node.get(i).getFrequency());
                    System.out.println(local_frequency_weight);
                    if (local_frequency_weight > frequency_weight) {
                        frequency_weight = local_frequency_weight;
                        letter = (char)('a' + i);
                    }
                }
            }
            System.out.println(node.getDepth());
            System.out.println(letter);
            System.out.println(frequency_weight);
            ret += letter;
            node = node.get(letter);
        }
        return ret;
    }
}

public class WordPredictor {

    private Trie trie = new Trie();

    public void load_dictionary(String dir) {
        try {
            Scanner sc = new Scanner(new File(dir));  
            sc.useDelimiter(" ");   //sets the delimiter pattern 
            while (sc.hasNextLine()){
                List<String> values = new ArrayList<String>();
                try (Scanner rsc = new Scanner(sc.nextLine())) {
                    rsc.useDelimiter(" ");
                    while (rsc.hasNext()) {
                        values.add(rsc.next());
                    }
                }
                if (values.get(2).contains("-")) {
                    continue;
                }
                //System.out.println(values.get(2) + " " +Integer.parseInt(values.get(1)));
                trie.insert(values.get(2), Integer.parseInt(values.get(1)));
            }
            sc.close();  //closes the scanner
        }
        catch (FileNotFoundException e) {
            System.out.println("File not found");
        }
        trie.assignDepth();
    }

    public String predict(String word) {
        return trie.findMaxFreq(word);
    }

}

/* This is the sample code */
/* 
public class priority {
    public static void main(String[] args) {
        WordPredictor word_predictor = new WordPredictor();
        word_predictor.load_dictionary("word_freq.txt");
        System.out.println(word_predictor.predict("appl"));
    }
}
*/
