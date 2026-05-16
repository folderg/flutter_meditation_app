package com.meditation.service;

import com.meditation.model.MeditationSettings;
import org.springframework.stereotype.Service;

@Service
public class SettingsService {

    private static final MeditationSettings DEFAULTS = new MeditationSettings(600, 4, 6, 0);

    private MeditationSettings currentSettings = new MeditationSettings(
        DEFAULTS.getMeditationDurationSec(),
        DEFAULTS.getBreathInSec(),
        DEFAULTS.getBreathOutSec(),
        DEFAULTS.getHoldSec()
    );

    public MeditationSettings getSettings() {
        return new MeditationSettings(
            currentSettings.getMeditationDurationSec(),
            currentSettings.getBreathInSec(),
            currentSettings.getBreathOutSec(),
            currentSettings.getHoldSec()
        );
    }

    public MeditationSettings updateSettings(MeditationSettings settings) {
        currentSettings = new MeditationSettings(
            settings.getMeditationDurationSec(),
            settings.getBreathInSec(),
            settings.getBreathOutSec(),
            settings.getHoldSec()
        );
        return getSettings();
    }

    public MeditationSettings resetToDefaults() {
        currentSettings = new MeditationSettings(
            DEFAULTS.getMeditationDurationSec(),
            DEFAULTS.getBreathInSec(),
            DEFAULTS.getBreathOutSec(),
            DEFAULTS.getHoldSec()
        );
        return getSettings();
    }

    public MeditationSettings getDefaults() {
        return DEFAULTS;
    }
}
