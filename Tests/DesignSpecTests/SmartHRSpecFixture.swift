import DesignSpec

/// SmartHR Design System を `DesignSpec` の最初の実インスタンスとして表現する。
/// 値は research/misc/2026-06-11-smarthr-ground-truth.md（smarthr-ui src 採取）に基づく実値。
///
/// これがコンパイル・round-trip すること自体が「スキーマが SmartHR の特異性
/// （warm grey / harmonic 型ランプ / char-relative 余白 / 二重 focus ring / system 書体委譲）
/// を失わず表現できる」ことの妥当性証明になる。後に BrandSmartHR へ移設する。
enum SmartHRSpecFixture {
    static let spec = DesignSpec(
        meta: BrandMeta(
            id: "smarthr",
            name: "SmartHR",
            sourceURL: "https://github.com/kufu/smarthr-ui",
            fidelityNotes: "smarthr-ui src/themes の実値に準拠。トークンのみ再現。",
            assetPolicy: "ロゴ・商標・専用書体は非同梱。SmartHR 自体が system-ui 委譲のため書体は fallback。"
        ),
        theme: VisualTheme(
            atmosphere: ["warm", "trustworthy", "business", "accessible"],
            summary: "warm grey を基調に、二重 focus ring と広い行間で可読性とアクセシビリティを前面化した業務 SaaS のトーン。"
        ),
        color: ColorSpec(
            primitives: [
                ColorToken(name: "BLACK", hex: "#030302", note: "warm black hwb(56,17,1)"),
                ColorToken(name: "WHITE", hex: "#ffffff"),
                ColorToken(name: "GREY_5", hex: "#f8f7f6", note: "warm grey"),
                ColorToken(name: "GREY_6", hex: "#f5f4f3"),
                ColorToken(name: "GREY_7", hex: "#f2f1f0"),
                ColorToken(name: "GREY_9", hex: "#edebe8"),
                ColorToken(name: "GREY_20", hex: "#d6d3d0"),
                ColorToken(name: "GREY_30", hex: "#c1bdb7"),
                ColorToken(name: "GREY_65", hex: "#706d65"),
                ColorToken(name: "GREY_100", hex: "#23221e"),
                ColorToken(name: "BLUE_100", hex: "#0077c7"),
                ColorToken(name: "BLUE_101", hex: "#0071c1"),
                ColorToken(name: "GREEN_100", hex: "#0f7f85"),
                ColorToken(name: "ORANGE_100", hex: "#f56121"),
                ColorToken(name: "RED_100", hex: "#e01e5a"),
                ColorToken(name: "YELLOW_100", hex: "#ffcc17"),
                ColorToken(name: "SMARTHR_BLUE", hex: "#00c4cc", note: "brand cyan"),
            ],
            roles: [
                ColorRole(role: "TEXT_BLACK", ref: "GREY_100"),
                ColorRole(role: "TEXT_GREY", ref: "GREY_65"),
                ColorRole(role: "TEXT_DISABLED", ref: "GREY_30"),
                ColorRole(role: "TEXT_LINK", ref: "BLUE_101"),
                ColorRole(role: "TEXT_WHITE", ref: "WHITE"),
                ColorRole(role: "MAIN", ref: "BLUE_100"),
                ColorRole(role: "OUTLINE", ref: "BLUE_100"),
                ColorRole(role: "DANGER", ref: "RED_100"),
                ColorRole(role: "WARNING_YELLOW", ref: "YELLOW_100"),
                ColorRole(role: "BRAND", ref: "SMARTHR_BLUE", note: "MAIN(blue) と別。ロゴ由来のシアン"),
                ColorRole(role: "BACKGROUND", ref: "GREY_5"),
                ColorRole(role: "BASE_GREY", ref: "GREY_6"),
                ColorRole(role: "OVER_BACKGROUND", ref: "GREY_7"),
                ColorRole(role: "HEAD", ref: "GREY_9"),
                ColorRole(role: "BORDER", ref: "GREY_20"),
            ],
            states: [
                ColorState(name: "hover", transform: .darken(0.05)),
                ColorState(name: "disabled", transform: .alpha(0.5)),
                ColorState(name: "link-hover", transform: .darken(0.062)),
            ]
        ),
        typography: TypographySpec(
            fontStack: FontStack(
                families: [],
                system: true,
                note: "smarthr-ui は system-ui, sans-serif に委譲。CJK 可読性は leading 1.5 で担保。"
            ),
            scaleModel: .harmonic(base: 1.0, scaleFactor: 6.0),
            ramp: [
                TypeStyle(role: "XXS", sizeRem: 6.0 / 9.0, weight: .regular, leadingRef: "normal"),
                TypeStyle(role: "XS", sizeRem: 6.0 / 8.0, weight: .regular, leadingRef: "normal"),
                TypeStyle(role: "S", sizeRem: 6.0 / 7.0, weight: .regular, leadingRef: "normal"),
                TypeStyle(role: "M", sizeRem: 1.0, weight: .regular, leadingRef: "normal"),
                TypeStyle(role: "L", sizeRem: 6.0 / 5.0, weight: .bold, leadingRef: "tight"),
                TypeStyle(role: "XL", sizeRem: 6.0 / 4.0, weight: .bold, leadingRef: "tight"),
                TypeStyle(role: "XXL", sizeRem: 2.0, weight: .bold, leadingRef: "tight"),
            ],
            leading: [
                LeadingToken(name: "none", multiplier: 1.0),
                LeadingToken(name: "tight", multiplier: 1.25),
                LeadingToken(name: "normal", multiplier: 1.5),
                LeadingToken(name: "relaxed", multiplier: 1.75),
            ]
        ),
        spacing: SpacingSpec(
            model: .charRelative(basePx: 8.0),
            steps: [
                SpacingStep(name: "NONE", value: 0, multiplier: 0),
                SpacingStep(name: "X3S", value: 4, multiplier: 0.25),
                SpacingStep(name: "XXS", value: 8, multiplier: 0.5),
                SpacingStep(name: "XS", value: 16, multiplier: 1.0),
                SpacingStep(name: "S", value: 24, multiplier: 1.5),
                SpacingStep(name: "M", value: 32, multiplier: 2.0),
                SpacingStep(name: "L", value: 40, multiplier: 2.5),
                SpacingStep(name: "XL", value: 48, multiplier: 3.0),
                SpacingStep(name: "XXL", value: 56, multiplier: 3.5),
                SpacingStep(name: "X3L", value: 64, multiplier: 4.0),
            ]
        ),
        radius: RadiusSpec(steps: [
            RadiusStep(name: "s", value: 4),
            RadiusStep(name: "m", value: 6),
            RadiusStep(name: "l", value: 8),
            RadiusStep(name: "full", value: 10000),
        ]),
        elevation: ElevationSpec(
            layers: [
                ElevationLayer(name: "BASE", yOffset: 0, blur: 4, opacity: 0.15, rawCSS: "rgba(3,3,2,.15) 0 0 4px 0"),
                ElevationLayer(name: "DIALOG", yOffset: 4, blur: 10, opacity: 0.30, rawCSS: "rgba(3,3,2,.30) 0 4px 10px 0"),
                ElevationLayer(name: "LAYER1", yOffset: 1, blur: 2, opacity: 0.30, rawCSS: "0 1px 2px 0 rgba(3,3,2,.30)"),
                ElevationLayer(name: "LAYER2", yOffset: 2, blur: 4, opacity: 0.30, rawCSS: "0 2px 4px 1px rgba(3,3,2,.30)"),
            ],
            focusRing: FocusRing(doubleRing: true, colorRef: "OUTLINE", note: "0 0 0 2px white, 0 0 0 4px OUTLINE")
        ),
        layout: LayoutSpec(
            principles: ["業務密度の高いテーブル/フォーム", "余白はタイポのリズムに従う(char-relative)"],
            breakpoints: []
        ),
        components: [
            ComponentSpec(
                archetype: "FocusIndicator",
                name: "二重リング focus",
                annotation: "白ギャップ+色の二重リングで背景色に依らずフォーカスを保証。アクセシビリティを前面化する SmartHR の指紋。",
                sourceURL: "https://github.com/kufu/smarthr-ui",
                fidelity: "shadow 値まで準拠"
            ),
            ComponentSpec(
                archetype: "FormControl",
                name: "FormControl",
                annotation: "label/help/error を構造化し、業務入力の認知負荷とミスを下げる。業務 SaaS の中核示唆。",
                sourceURL: "https://github.com/kufu/smarthr-ui"
            ),
        ],
        guidance: Guidance(
            dos: ["本文は leading 1.5", "余白は char-relative スケールで一貫させる", "フォーカスは二重リング"],
            donts: ["純黒/純グレーを使わない(warm 基調)", "MAIN(blue) と BRAND(cyan) を混同しない"],
            agentPrompt: "warm grey を基調に、広い行間と二重 focus ring で、信頼感のある業務 SaaS UI を生成せよ。"
        )
    )
}
