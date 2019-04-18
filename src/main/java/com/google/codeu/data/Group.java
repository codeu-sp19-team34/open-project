package com.google.codeu.data;

import java.math.BigInteger;
import java.util.Random;

public class Group {

    private int id;
    private int creator_id;
    private String name;
    private String course;
    private int size;
    private int max_size;

    public int getGroupId() {
        return id;
    }

    public int getGroupCreatorId() {
        return creator_id;
    }

    public String getGroupName() {
        return name;
    }

    public String getGroupCourse() {
        return course;
    }

    public int getGroupSize() {
        return size;
    }

    public int getGroupMaxSize() {
        return max_size;
    }

    public Group(int id, int creator_id, String name, String course, int size, int max_size) {
        this.id = id;
        this.creator_id = creator_id;
        this.name = name;
        this.course = course;
        this.size = size;
        this.max_size = max_size;
    }

    public static void main(String[] args){
        int id = Integer.parseInt(args[0]);
        int creator_id = Integer.parseInt(args[1]);
        String name = args[2];
        String course = args[3];
        int size = Integer.parseInt(args[4]);
        int max_size = Integer.parseInt(args[5]);

        Group g = new Group(id, creator_id, name, course, size, max_size);

        System.out.println("Groups: ");
        System.out.println(g.getGroupId());
        System.out.println(g.getGroupName());
        System.out.println(g.getGroupCourse());
    }
}
