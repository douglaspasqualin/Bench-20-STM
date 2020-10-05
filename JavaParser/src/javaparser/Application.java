package javaparser;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 *
 * @author Douglas Pereira Pasqualin
 */
public class Application implements Comparable<Application> {

    private String name;
    private Integer numberThreads;
    private Map<String, List<Result>> results;

    public Application(String name, Integer numberThreads) {
        results = new HashMap<>();
        this.name = name;
        this.numberThreads = numberThreads;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getNumberThreads() {
        return numberThreads;
    }

    public void setNumberThreads(Integer numberThreads) {
        this.numberThreads = numberThreads;
    }

    public Map<String, List<Result>> getResults() {
        return results;
    }

    public void setResults(Map<String, List<Result>> results) {
        this.results = results;
    }

    public void addResult(String configuration, Result result) {
        if (results.get(configuration) != null) {
            results.get(configuration).add(result);
        } else {
            ArrayList<Result> arrayList = new ArrayList<>();
            arrayList.add(result);
            results.put(configuration, arrayList);
        }
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 17 * hash + Objects.hashCode(this.name);
        hash = 17 * hash + Objects.hashCode(this.numberThreads);
        return hash;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final Application other = (Application) obj;
        if (!Objects.equals(this.name, other.name)) {
            return false;
        }
        if (!Objects.equals(this.numberThreads, other.numberThreads)) {
            return false;
        }
        return true;
    }

    @Override
    public int compareTo(Application t) {
        int compare = this.numberThreads.compareTo(t.numberThreads);
        if (compare == 0) {
            compare = this.name.compareTo(t.name);
        }
        return compare;
    }

}
