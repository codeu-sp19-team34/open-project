package com.google.codeu.data;

import java.math.BigInteger;
import java.util.Random;

public class Group {

    private int gid;
    private int gcreator_id;
    private String name;
    private String course;
    private int size;
    private int max_size;

    public int getGroupId() {
        return gid;
    }

    public int getGroupCreatorId() {
        return gcreator_id;
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

    public Group(int gid, int gcreator_id, String name, String course, int size, int max_size) {
        this.gid = gid;
        this.gcreator_id = gcreator_id;
        this.name = name;
        this.course = course;
        this.size = size;
        this.max_size = max_size;
    }

    public static void main(String[] args){
        int gid = Integer.parseInt(args[0]);
        int gcreator_id = Integer.parseInt(args[1]);
        String name = args[2];
        String course = args[3];
        int size = Integer.parseInt(args[4]);
        int max_size = Integer.parseInt(args[5]);

        Group g = new Group(gid, gcreator_id, name, course, size, max_size);

        System.out.println("Groups: ");
        System.out.println(g.getGroupId());
        System.out.println(g.getGroupName());
        System.out.println(g.getGroupCourse());
    }
}
