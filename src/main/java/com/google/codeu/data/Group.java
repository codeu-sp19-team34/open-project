package com.google.codeu.data;
import java.util.UUID;

public class Group {

    private String name;
    private String course;
    private Integer size;
    private Integer max_size;

    public Group(String name, String course, Integer size, Integer max_size) {
        this.name = name;
        this.course = course;
        this.size = size;
        this.max_size = max_size;
    }

    public String getName() {
        return name;
    }

    public String getCourse() {
        return course;
    }

    public Integer getGroupSize() {
        return size;
    }

    public Integer getMaxSize() {
        return max_size;
    }
}
