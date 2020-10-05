package javaparser;

/**
 *
 * @author Douglas Pereira Pasqualin
 */
public class Result {

    private String executionTime;
    private String commits;
    private String aborts;

    public Result(String executionTime, String commits, String aborts) {
        this.executionTime = executionTime;
        this.commits = commits;
        this.aborts = aborts;
    }

    public String getExecutionTime() {
        return executionTime;
    }

    public void setExecutionTime(String executionTime) {
        this.executionTime = executionTime;
    }

    public String getAborts() {
        return aborts;
    }

    public void setAborts(String aborts) {
        this.aborts = aborts;
    }

    public String getCommits() {
        return commits;
    }

    public void setCommits(String commits) {
        this.commits = commits;
    }
    

    @Override
    public String toString() {
        if (executionTime != null) {
            return executionTime;
        } else if (aborts != null) {
            return aborts;
        } else {
            return commits;
        }
    }

}
