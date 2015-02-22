package com.redseal.featureset;

public interface SomeInterface {
    int getInt();
    long getLong();
    String getString();
    boolean getBoolean();
    double getDouble();
    String[] getList();

    void setInt(int x);
    void setLong(long x);
    void setString(String x);
    void setBoolean(boolean x);
    void setDouble(double x);
    void setList(String... args);

    String joinList(String sep);
}