package com.meditation.model;

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;

public class MeditationSettings {

    @Min(30)
    @Max(3600)
    private int meditationDurationSec = 600;

    @Min(1)
    @Max(30)
    private int breathInSec = 4;

    @Min(1)
    @Max(30)
    private int breathOutSec = 6;

    @Min(0)
    @Max(30)
    private int holdSec = 0;

    public MeditationSettings() {}

    public MeditationSettings(int meditationDurationSec, int breathInSec, int breathOutSec, int holdSec) {
        this.meditationDurationSec = meditationDurationSec;
        this.breathInSec = breathInSec;
        this.breathOutSec = breathOutSec;
        this.holdSec = holdSec;
    }

    public int getMeditationDurationSec() { return meditationDurationSec; }
    public void setMeditationDurationSec(int meditationDurationSec) { this.meditationDurationSec = meditationDurationSec; }
    public int getBreathInSec() { return breathInSec; }
    public void setBreathInSec(int breathInSec) { this.breathInSec = breathInSec; }
    public int getBreathOutSec() { return breathOutSec; }
    public void setBreathOutSec(int breathOutSec) { this.breathOutSec = breathOutSec; }
    public int getHoldSec() { return holdSec; }
    public void setHoldSec(int holdSec) { this.holdSec = holdSec; }
}
