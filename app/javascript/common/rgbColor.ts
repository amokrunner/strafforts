export class RgbColor {
    public r: number;

    public g: number;

    public b: number;

    constructor(r: number, g: number, b: number) {
        this.r = r;
        this.g = g;
        this.b = b;
    }

    public toString(alpha?: number) {
        return alpha
            ? `rgba(${this.r}, ${this.g}, ${this.b}, ${alpha})`
            : `rgba(${this.r}, ${this.g}, ${this.b})`;
    }
}
