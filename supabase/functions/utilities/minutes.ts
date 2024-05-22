export function getMinutesBetweenDates({
  currentTime,
  endTime,
}: {
  currentTime: number;
  endTime: number;
}) {
  return Math.ceil(
    (endTime - currentTime) / (1000 * 60),
  ) - 180;
}
