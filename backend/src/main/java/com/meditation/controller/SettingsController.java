package com.meditation.controller;

import com.meditation.model.MeditationSettings;
import com.meditation.service.SettingsService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@RestController
@RequestMapping("/api/settings")
@CrossOrigin(origins = "*")
public class SettingsController {

    private final SettingsService settingsService;

    public SettingsController(SettingsService settingsService) {
        this.settingsService = settingsService;
    }

    @GetMapping
    public ResponseEntity<MeditationSettings> getSettings() {
        return ResponseEntity.ok(settingsService.getSettings());
    }

    @PutMapping
    public ResponseEntity<MeditationSettings> updateSettings(@Valid @RequestBody MeditationSettings settings) {
        return ResponseEntity.ok(settingsService.updateSettings(settings));
    }

    @PostMapping("/reset")
    public ResponseEntity<MeditationSettings> resetToDefaults() {
        return ResponseEntity.ok(settingsService.resetToDefaults());
    }

    @GetMapping("/defaults")
    public ResponseEntity<MeditationSettings> getDefaults() {
        return ResponseEntity.ok(settingsService.getDefaults());
    }
}
